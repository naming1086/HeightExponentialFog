using UnityEngine;
[ExecuteInEditMode]
public class Fog : MonoBehaviour
{
    public bool enable;
    [Header("雾")]
    public Color fogColor;

    [Header("雾浓度与高度")]
    public float fogHeight;
    [Range(0,1)]public float fogDensity;
    [Min(0f)]public float fogFalloff;

    [Header("雾浓度与距离")]
    [Range(-300, 300)] public float fogStartDis;
    [Range(0, 200)] public float fogGradientDis;

    [Header("雾颜色与太阳颜色"), Range(0.0001f, 10.0f)]
    public float fogInscatteringExp;




    private static readonly int FogColor = Shader.PropertyToID("_FogColor");
    private static readonly int FogGlobalDensity = Shader.PropertyToID("_FogGlobalDensity");
    private static readonly int FogFallOff = Shader.PropertyToID("_FogFallOff");
    private static readonly int FogHeight = Shader.PropertyToID("_FogHeight");
    private static readonly int FogStartDis = Shader.PropertyToID("_FogStartDis");
    private static readonly int FogInscatteringExp = Shader.PropertyToID("_FogInscatteringExp");
    private static readonly int FogGradientDis = Shader.PropertyToID("_FogEndDis");

    void OnValidate()
    {
        Shader.SetGlobalColor(FogColor, fogColor);
        Shader.SetGlobalFloat(FogGlobalDensity, fogDensity);
        Shader.SetGlobalFloat(FogFallOff, fogFalloff);
        Shader.SetGlobalFloat(FogHeight, fogHeight);
        Shader.SetGlobalFloat(FogStartDis, fogStartDis);
        Shader.SetGlobalFloat(FogInscatteringExp, fogInscatteringExp);
        Shader.SetGlobalFloat(FogGradientDis,fogGradientDis);
        if (enable)
        {
            Shader.EnableKeyword("_FOG_ON");
        }
        else
        {
            Shader.DisableKeyword("_FOG_ON");
        }
    }
}
