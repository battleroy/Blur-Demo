using UnityEngine;
using UnityEngine.Rendering;


public class CommandBufferGreenScreenSetup : MonoBehaviour 
{
    const CameraEvent GreenScreenEvent = CameraEvent.AfterForwardAlpha;
    CommandBuffer cb;
    Camera mainCamera;


    void Awake()
    {
        Material greenScreenMat = Resources.Load<Material>("GreenScreen_post_process");
        cb = new CommandBuffer();
        cb.name = "Green Screen Post Process";
        cb.Blit(BuiltinRenderTextureType.CameraTarget, BuiltinRenderTextureType.CameraTarget, greenScreenMat);
        mainCamera = Camera.main;
    }


    void OnEnable()
    {
        mainCamera.AddCommandBuffer(GreenScreenEvent, cb);
    }


    void OnDisable()
    {
        mainCamera.RemoveCommandBuffer(GreenScreenEvent, cb);    
    }
}
