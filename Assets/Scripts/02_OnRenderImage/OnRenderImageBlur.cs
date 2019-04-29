using UnityEngine;


public class OnRenderImageBlur : MonoBehaviour 
{
    Material blurMaterial;


    void Awake()
    {
        blurMaterial = Resources.Load<Material>("Blur_post_process");
    }


    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        RenderTexture rt = RenderTexture.GetTemporary(source.width, source.height);
        Graphics.Blit(source, rt, blurMaterial, 0);
        Graphics.Blit(rt, destination, blurMaterial, 1);
        RenderTexture.ReleaseTemporary(rt);
    }
}
