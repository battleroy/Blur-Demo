using UnityEngine;


public class BlurSwitch : MonoBehaviour 
{
    public MonoBehaviour blurBehaviour;

    void Update()
    {
        if (blurBehaviour != null && Input.GetKeyDown(KeyCode.Space))
        {
            blurBehaviour.enabled = !blurBehaviour.enabled;
        }
    }
}
