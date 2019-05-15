using UnityEngine;
using UnityEngine.Rendering;

// https://forum.unity.com/threads/graphics-blit-vs-grabpass-vs-rendertexture.523825/
public class CommandBufferBlurSetup : MonoBehaviour
{
    const CameraEvent BlurEvent = CameraEvent.AfterForwardAlpha;

    Material blurMaterial;
    int rtId;
    Camera blurCamera;
    CommandBuffer cb;
    int downsample;

    void Awake()
    {
        blurMaterial = Resources.Load<Material>("Blur_post_process");
        rtId = Shader.PropertyToID("CommandBuffer_blurTex");
        blurCamera = Camera.main;
        cb = CreateBlurCommandBuffer();
    }


    void OnEnable()
    {
        blurCamera.AddCommandBuffer(BlurEvent, cb);
    }


    void OnDisable()
    {
        blurCamera.RemoveCommandBuffer(BlurEvent, cb);
    }


    void Update()
    {
        for (int i = 0; i < 10; i++)
        {
            KeyCode codeToTest = (KeyCode)((int)KeyCode.Alpha0 + i);
            if (Input.GetKeyDown(codeToTest))
            {
                downsample = i;
                blurCamera.RemoveCommandBuffer(BlurEvent, cb);
                cb = CreateBlurCommandBuffer();
                blurCamera.AddCommandBuffer(BlurEvent, cb);
            }
        }
    }


    CommandBuffer CreateBlurCommandBuffer()
    {
        cb = new CommandBuffer { name = "Blur Post Process" };
        const string sampleName = "Blur";
        cb.BeginSample(sampleName);
        cb.GetTemporaryRT(rtId, Screen.width >> downsample, Screen.height >> downsample);
        if (downsample > 0)
        {
            string subSampleName = $"downsampled = {downsample}";
            cb.BeginSample(subSampleName);
            cb.Blit(BuiltinRenderTextureType.CameraTarget, rtId);
            cb.Blit(rtId, rtId, blurMaterial, 0);
            cb.Blit(rtId, BuiltinRenderTextureType.CameraTarget, blurMaterial, 1);
            cb.EndSample(subSampleName);
        }
        else
        {
            string subSampleName = "full-size";
            cb.BeginSample(subSampleName);
            cb.Blit(BuiltinRenderTextureType.CameraTarget, rtId, blurMaterial, 0);
            cb.Blit(rtId, BuiltinRenderTextureType.CameraTarget, blurMaterial, 1);
            cb.EndSample(subSampleName);
        }
        cb.ReleaseTemporaryRT(rtId);
        cb.EndSample(sampleName);

        return cb;
    }
}
