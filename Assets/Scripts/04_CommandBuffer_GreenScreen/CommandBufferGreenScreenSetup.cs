using UnityEngine;
using UnityEngine.Rendering;


public class CommandBufferGreenScreenSetup : MonoBehaviour 
{
    const CameraEvent GreenScreenEvent = CameraEvent.AfterForwardAlpha;
    CommandBuffer cb;
    Camera targetCamera;


    void Awake()
    {
        Material greenScreenMat = Resources.Load<Material>("GreenScreen_post_process");
        cb = new CommandBuffer();
        cb.name = "Green Screen Post Process";
        cb.Blit(BuiltinRenderTextureType.CameraTarget, BuiltinRenderTextureType.CameraTarget, greenScreenMat);
        targetCamera = GameObject.Find("Late Camera").GetComponent<Camera>();
    }


    void OnEnable()
    {
        targetCamera.AddCommandBuffer(GreenScreenEvent, cb);
    }


    void OnDisable()
    {
        targetCamera.RemoveCommandBuffer(GreenScreenEvent, cb);    
    }
}
