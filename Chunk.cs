using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Tilemaps;

public class ChunkTile
{
    public Vector2Int position;
    public float height;
    public int hiddenHeight;
    public List<Tile> tiles;

    public ChunkTile(Vector2Int p, float h, int hH)
    {
        position = p;
        height = h;
        hiddenHeight = hH;
        SetTiles();
    }

    private void SetTiles(int[,] localHeights)
    {
        if(hiddenHeight >= (int)height)
        {
            tiles = null;
        }
        else
        {
            tiles = new List<Tile>();

        }
    }
}

public class Chunk
{
    public Dictionary<Vector2Int, string> heightRelations;
    public readonly Vector2Int position;

    private readonly int maxElevation;
    private readonly int chunkSize;
    private readonly NoiseGenerator noiseGen;
    private readonly TerrainAssets terrainAssets;
    private Dictionary<Vector2Int, float> heightMap;

    public Chunk(Vector2Int p, int mE, int cS, NoiseGenerator _ng, TerrainAssets tA)
    {
        position = p;
        chunkSize = cS;
        maxElevation = mE;
        noiseGen = _ng;
        heightMap = new();
        InitializeHeightMap();
        heightRelations = new();
        InitializeHeightRelations();
        terrainAssets = tA;
    }


    private int GetHeight(Vector2Int vec)
    {
        if (heightMap.ContainsKey(vec))
        {
            return (int)heightMap[vec];
        }
        else
        {
            return (int)(noiseGen.GetNoiseValue(position.x + vec.x, position.y + vec.y) * maxElevation);
        }
    }

    private int[,] GetLocalHeights(Vector2Int vec)
    {
        int[,] heights = new int[3, 3];
        heights[0, 2] = GetHeight(new Vector2Int(vec.x - 1, vec.y + 1));
        heights[1, 2] = GetHeight(new Vector2Int(vec.x    , vec.y + 1));
        heights[2, 2] = GetHeight(new Vector2Int(vec.x + 1, vec.y + 1));

        heights[0, 1] = GetHeight(new Vector2Int(vec.x - 1, vec.y    ));
        heights[1, 1] = GetHeight(new Vector2Int(vec.x    , vec.y    ));
        heights[2, 1] = GetHeight(new Vector2Int(vec.x + 1, vec.y    ));

        heights[0, 0] = GetHeight(new Vector2Int(vec.x - 1, vec.y - 1));
        heights[1, 0] = GetHeight(new Vector2Int(vec.x    , vec.y - 1));
        heights[2, 0] = GetHeight(new Vector2Int(vec.x + 1, vec.y - 1));

        return heights;
    }

    private void CorrectIncompatibeHeight(Vector2Int vec)
    {
        int[,] heights = GetLocalHeights(vec);
        int center = heights[1, 1];
        bool decrease = true;
        bool increase = true;
        while (decrease || increase)
        {
            decrease = false;
            increase = false;
            // Check if need to decrease height
            if (
                    (heights[1, 2] < center && heights[1, 0] < center) //check top & bottom
                    ||
                    (heights[0, 1] < center && heights[2, 1] < center) //check left & right
                    ||
                    (
                        ( //check top,left,right,bottom
                            heights[1, 2] == center && heights[0, 1] == center &&
                            heights[2, 1] == center && heights[1, 0] == center
                        )
                        &&
                        ( //check diagonals
                            (heights[0, 2] < center && heights[2, 0] < center)
                            ||
                            (heights[2, 2] < center && heights[0, 0] < center)
                        )
                    )
                    ||
                    ( //check bridge cases
                        (heights[1, 0] < center && ((heights[0, 2] < center && heights[2, 1] < center)
                                                        ||
                                                        (heights[2, 2] < center && heights[0, 1] < center)))
                        ||
                        (heights[1, 2] < center && ((heights[2, 1] < center && heights[0, 0] < center)
                                                        ||
                                                        (heights[0, 1] < center && heights[2, 0] < center)))
                    )
                )
            {
                heightMap[vec] -= 1.0f;
                center -= 1;
                decrease = true;
            }
            // Check if need to increase height
            else if
                (
                    (heights[1, 2] > center && heights[1, 0] > center) //check top & bottom
                    ||
                    (heights[0, 1] > center && heights[2, 1] > center) //check left & right
                    ||
                    (
                        ( //check top,left,right,bottom
                            heights[1, 2] == center && heights[0, 1] == center &&
                            heights[2, 1] == center && heights[1, 0] == center
                        )
                        &&
                        ( //check diagonals
                            (heights[0, 2] > center && heights[2, 0] > center)
                            ||
                            (heights[2, 2] > center && heights[0, 0] > center)
                        )
                    )
                    ||
                    ( //check bridge cases
                        (heights[1, 0] > center && ((heights[0, 2] > center && heights[2, 1] > center)
                                                        ||
                                                        (heights[2, 2] > center && heights[0, 1] > center)))
                        ||
                        (heights[1, 2] > center && ((heights[2, 1] > center && heights[0, 0] > center)
                                                        ||
                                                        (heights[0, 1] > center && heights[2, 0] > center)))
                    )
                )
            {
                heightMap[vec] += 1.0f;
                center += 1;
                increase = true;
            }
        }
        
    }

    private void InitializeHeightMap()
    {
        for (int x = 0; x < chunkSize; x++)
        {
            for (int y = 0; y < chunkSize; y++)
            {
                Vector2Int vec = new(x + position.x, y + position.y);
                heightMap.Add(vec, noiseGen.GetNoiseValue(vec.x, vec.y) * maxElevation);
            }
        }
        
        for (int x = 0; x < chunkSize; x++)
        {
            for (int y = 0; y < chunkSize; y++)
            {
                CorrectIncompatibeHeight(new Vector2Int(x + position.x, y + position.y));
            }
        }
    }

    private string GetLocalHeightRelations(Vector2Int vec)
    {
        int[,] heights = GetLocalHeights(vec);
        int centerHeight = heights[1, 1];
        string relations = "";
        for(int y = 2; 0 <= y; y--)
        {
            for(int x = 0; x < 3; x++)
            {
                if (heights[x, y] > centerHeight)
                    { relations += '>'; }
                else if (heights[x, y] < centerHeight)
                    { relations += '<'; }
                else
                    { relations += '='; }
            }
        }
        return relations;
    }

    private void InitializeHeightRelations()
    {
        for (int x = 0; x < chunkSize; x++)
        {
            for (int y = 0; y < chunkSize; y++)
            {
                Vector2Int vec = new(x + position.x, y + position.y);
                heightRelations.Add(vec, GetLocalHeightRelations(vec));
            }
        }
    }
}
