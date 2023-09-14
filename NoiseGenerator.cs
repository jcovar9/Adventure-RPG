using UnityEngine;

public class NoiseGenerator : MonoBehaviour
{
    private int seed;
    private float scale;
    private int octaves;
    private float persistance;
    private float lacunarity;
    private System.Random prng;
    private Vector2[] octaveOffsets;
    private float maxNoiseHeight;
    private float minNoiseHeight;

    public void Init(int[] bounds, int _seed, float _scale, int _oct, float _pers, float _lacu)
    {
        seed = _seed;
        scale = _scale;
        octaves = _oct;
        persistance = _pers;
        lacunarity = _lacu;
        prng = new System.Random(seed);

        octaveOffsets = new Vector2[octaves];
        for (int i = 0; i < octaves; i++)
        {
            float offsetX = prng.Next(-100000, 100000);
            float offsetY = prng.Next(-100000, 100000);
            octaveOffsets[i] = new Vector2(offsetX, offsetY);
        }

        maxNoiseHeight = float.MinValue;
        minNoiseHeight = float.MaxValue;
        SetNoiseHeightBounds(bounds[0], bounds[1], bounds[2], bounds[3]);
    }

    private float GetNoiseHeight(int x, int y)
    {
        if (scale <= 0) scale = 0.0001f;
        float amplitude = 1;
        float frequency = 1;
        float noiseHeight = 0;

        for (int i = 0; i < octaves; i++)
        {
            float sampleX = x / scale * frequency + octaveOffsets[i].x;
            float sampleY = y / scale * frequency + octaveOffsets[i].y;

            float perlinValue = Mathf.PerlinNoise(sampleX, sampleY) * 2 - 1;
            noiseHeight += perlinValue * amplitude;

            amplitude *= persistance;
            frequency *= lacunarity;
        }
        return noiseHeight;
    }

    private void SetNoiseHeightBounds(int xmin, int xmax, int ymin, int ymax)
    {
        for (int x = xmin; x < xmax; x++)
        {
            for(int y = ymin; y < ymax; y++)
            {
                float noiseHeight = GetNoiseHeight(x, y);

                if (noiseHeight > maxNoiseHeight)
                {
                    maxNoiseHeight = noiseHeight;
                }
                else if (noiseHeight < minNoiseHeight)
                {
                    minNoiseHeight = noiseHeight;
                }
            }
        }
    }

    public float GetNoiseValue(int x, int y)
    {
        float noiseHeight = GetNoiseHeight(x, y);

        if (noiseHeight > maxNoiseHeight)
        {
            maxNoiseHeight = noiseHeight;
        } else if (noiseHeight < minNoiseHeight)
        {
            minNoiseHeight = noiseHeight;
        }
        
        return Mathf.InverseLerp(minNoiseHeight, maxNoiseHeight, noiseHeight);
    }

}
