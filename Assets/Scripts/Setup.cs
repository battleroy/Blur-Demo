using UnityEngine;
using UnityEngine.SceneManagement;


public class Setup : MonoBehaviour 
{
    [SerializeField] string additiveSceneName;

    void Awake()
    {
        Application.targetFrameRate = 100000;
        SceneManager.LoadScene(additiveSceneName, LoadSceneMode.Additive);
    }
}
