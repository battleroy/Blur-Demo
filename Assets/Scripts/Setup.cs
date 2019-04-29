using UnityEngine;
using UnityEngine.SceneManagement;


public class Setup : MonoBehaviour 
{
    [SerializeField] string additiveSceneName;

    void Awake()
    {
        Application.targetFrameRate = 100000;
        if (!SceneManager.GetSceneByName(additiveSceneName).IsValid())
        {
            SceneManager.LoadScene(additiveSceneName, LoadSceneMode.Additive);
        }
    }
}
