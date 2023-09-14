using System.Collections.Generic;
using System.Text;
using UnityEngine;
using UnityEngine.Tilemaps;

public class TerrainGenerator : MonoBehaviour
{
    #region Properties
    // Noise Generator
    private NoiseGenerator noiseGen;
    // Terrain Assets
    private TerrainAssets terrainAssets;

    // Chunk Config Fields
    [SerializeField] public int chunkRenderDistX = 1;
    [SerializeField] public int chunkRenderDistY = 1;
    [SerializeField] public int chunkSize = 16;
    [SerializeField] public int maxAltitude = 100;
    private Dictionary<Vector2Int, Chunk> chunks;

    // Noise Config Fields
    [SerializeField] public int seed;
    [SerializeField] public float scale;
    [SerializeField] public int octaves;
    [Range(0,1)] [SerializeField] public float persistance;
    [SerializeField] public float lacunarity;
    [SerializeField] public bool autoupdate;

    #endregion

    #region Unity Functions
    private void OnValidate()
    {
        if(chunkRenderDistX < 1) chunkRenderDistX = 1;
        if(chunkRenderDistY < 1) chunkRenderDistY = 1;
        if(lacunarity < 1) lacunarity = 1;
        if(octaves < 0) octaves = 0;
    }

    void Start()
    {
        chunks = new Dictionary<Vector2Int, Chunk>();
        InitializeTerrain();
    }
    #endregion

    public void InitializeTerrain()
    {
        terrainAssets = gameObject.AddComponent<TerrainAssets>();

        noiseGen = gameObject.AddComponent<NoiseGenerator>();
        int[] bounds = new int[] {  chunkRenderDistX * chunkSize * -1, chunkRenderDistX * chunkSize,
                                    chunkRenderDistY * chunkSize * -1, chunkRenderDistY * chunkSize };
        noiseGen.Init(bounds, seed, scale, octaves, persistance, lacunarity);

        Chunk chunk = new(new Vector2Int(0, 0), maxAltitude, chunkSize, noiseGen, terrainAssets);
        chunks.Add(new Vector2Int(0,0), chunk);
    }

}
