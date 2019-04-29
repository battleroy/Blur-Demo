using UnityEngine;
using UnityEngine.UI;


public class FpsMeter : MonoBehaviour 
{
    const float TimeRate = 1.0f;

    [SerializeField] Text text;

    float timeAccumulator;
    int framesTaken;

    void Update()
    {
        ++framesTaken;
        timeAccumulator += Time.unscaledDeltaTime;
        if (timeAccumulator >= TimeRate)
        {
            int fps = (int)(framesTaken / timeAccumulator);
            text.text = string.Format("FPS = {0}", fps.ToString());

            timeAccumulator = 0.0f;
            framesTaken = 0;
        }
    }
}
