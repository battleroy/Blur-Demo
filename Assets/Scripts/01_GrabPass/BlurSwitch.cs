using UnityEngine;


public class BlurSwitch : MonoBehaviour 
{
    [SerializeField] MonoBehaviour blurBehaviour;

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            blurBehaviour.enabled = !blurBehaviour.enabled;
        }
    }
}
