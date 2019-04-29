using UnityEngine;


public class OnRenderImageSetup : MonoBehaviour 
{
    void Awake()
    {
        OnRenderImageBlur blur = Camera.main.gameObject.AddComponent<OnRenderImageBlur>();
        Camera.main.gameObject.AddComponent<BlurSwitch>().blurBehaviour = blur;
    }
}
