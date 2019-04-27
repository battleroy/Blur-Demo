using UnityEngine;
using UnityEngine.UI;


public class FpsMeter : MonoBehaviour 
{
    const int FrameRate = 8;

    [SerializeField] Text text;

    float fpsAccumulator;
    int framesTaken;

    void Update()
    {
        fpsAccumulator += 1.0f / Time.unscaledDeltaTime;
        if (++framesTaken >= FrameRate)
        {
            int fps = (int)(fpsAccumulator / FrameRate);
            text.text = string.Format("FPS = {0}", fps.ToString());

            fpsAccumulator = 0.0f;
            framesTaken = 0;
        }
    }
}
