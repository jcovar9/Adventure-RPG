using System.Collections.Generic;
using UnityEngine;

public class TerrainNoiseMap : MonoBehaviour
{
    /*
    private int xmin; private int xmax;
    private int ymin; private int ymax;

    private string noiseMapType;

    private NoiseGenerator noiseGen;
    public Dictionary<Vector2Int, float> noiseMap;

    public void Init(string nmType)
    {
        noiseMapType = nmType;
        noiseGen = gameObject.AddComponent<NoiseGenerator>();
        noiseMap = new();
    }

    public void SetNoiseMap(int[] bounds, int _seed, float _scale, int _oct, float _pers, float _lacu)
    {
        xmin = bounds[0]; xmax = bounds[1];
        ymin = bounds[2]; ymax = bounds[3];
        noiseGen.Init(bounds, _seed, _scale, _oct, _pers, _lacu);
        noiseMap.Clear();
        MakeChangeToNoiseMap("add", xmin, xmax, ymin, ymax);
        MakeChangeToNoiseMap("correct", xmin, xmax, ymin, ymax);
    }

    // Make 2D changes to biome map depending on change parameter and INCLUSIVE boundaries
    private void MakeChangeToNoiseMap(string change, int xmin, int xmax, int ymin, int ymax)
    {
        for (int x = xmin; x <= xmax; x++)
        {
            for (int y = ymin; y <= ymax; y++)
            {
                Vector2Int vec = new(x, y);
                switch (change)
                {
                    case "add":
                        noiseMap.Add(vec, GetNoiseInt(vec));
                        break;
                    case "correct":
                        CorrectIncompatibility(vec, 0);
                        break;
                    case "remove":
                        noiseMap.Remove(vec);
                        break;
                    default:
                        break;
                }
            }
        }
    }

    #region Noise Map Movement Functions
    public void MoveNoiseMapNorth()
    {
        MakeChangeToNoiseMap("add"    , xmin, xmax, ymax + 1, ymax + 1);
        MakeChangeToNoiseMap("correct", xmin, xmax, ymax    , ymax + 1);
        MakeChangeToNoiseMap("remove" , xmin, xmax, ymin    , ymin    );

        ymin += 1;
        ymax += 1;
    }

    public void MoveNoiseMapSouth()
    {
        MakeChangeToNoiseMap("add"    , xmin, xmax, ymin - 1, ymin - 1);
        MakeChangeToNoiseMap("correct", xmin, xmax, ymin - 1, ymin    );
        MakeChangeToNoiseMap("remove" , xmin, xmax, ymax    , ymax    );

        ymin -= 1;
        ymax -= 1;
    }

    public void MoveNoiseMapEast()
    {
        MakeChangeToNoiseMap("add"    , xmax + 1, xmax + 1, ymin, ymax);
        MakeChangeToNoiseMap("correct", xmax    , xmax + 1, ymin, ymax);
        MakeChangeToNoiseMap("remove" , xmin    , xmin    , ymin, ymax);

        xmin += 1;
        xmax += 1;
    }

    public void MoveNoiseMapWest()
    {
        MakeChangeToNoiseMap("add"    , xmin - 1, xmin - 1, ymin, ymax);
        MakeChangeToNoiseMap("correct", xmin - 1, xmin    , ymin, ymax);
        MakeChangeToNoiseMap("remove" , xmax    , xmax    , ymin, ymax);

        xmin -= 1;
        xmax -= 1;
    }

    #endregion


    #region Helper Functions
    // Recursively corrects incompatibilities in the noise ints
    private void CorrectIncompatibility(Vector2Int vec, int recursiveLvl)
    {
        if (noiseMap.ContainsKey(vec))
        {
            List<int> noiseInts3x3 = GetNoiseInts3x3(vec);
            if (ShouldChangeCenterNoiseInt(noiseInts3x3))
            {
                int nearbyNoiseInt = GetNearbyNoiseInt(noiseInts3x3);
                noiseMap[vec] = nearbyNoiseInt;
                List<Vector2Int> neighborVecs = Get3x3Vectors(vec);
                neighborVecs.RemoveAt(4);
                foreach (Vector2Int neighborVec in neighborVecs)
                {
                    CorrectIncompatibility(neighborVec, recursiveLvl + 1);
                }
            }
        }
    }

    // Returns a list of noise ints representing the 3x3 centered on given vector
    public List<int> GetNoiseInts3x3(Vector2Int vec)
    {
        List<Vector2Int> vecs = Get3x3Vectors(vec);
        return new List<int> {
            GetNoiseInt(vecs[0]), GetNoiseInt(vecs[1]), GetNoiseInt(vecs[2]) ,
            GetNoiseInt(vecs[3]), GetNoiseInt(vecs[4]), GetNoiseInt(vecs[5]) ,
            GetNoiseInt(vecs[6]), GetNoiseInt(vecs[7]), GetNoiseInt(vecs[8])
        };
    }

    // Returns a list of vectors representing a 3x3 centered on given vector
    private List<Vector2Int> Get3x3Vectors(Vector2Int vec)
    {
        return new List<Vector2Int> {
            new Vector2Int(vec.x - 1, vec.y + 1) ,
            new Vector2Int(vec.x    , vec.y + 1) ,
            new Vector2Int(vec.x + 1, vec.y + 1) ,

            new Vector2Int(vec.x - 1, vec.y    ) ,
            new Vector2Int(vec.x    , vec.y    ) ,
            new Vector2Int(vec.x + 1, vec.y    ) ,

            new Vector2Int(vec.x - 1, vec.y - 1) ,
            new Vector2Int(vec.x    , vec.y - 1) ,
            new Vector2Int(vec.x + 1, vec.y - 1)
        };
    }

    // Returns the given vector's noise int
    private int GetNoiseInt(Vector2Int vec)
    {
        if (noiseMap.ContainsKey(vec))
            return noiseMap[vec];
        
        else
            return terrainAssets.NoiseToInt(noiseMapType, noiseGen.GetNoiseValue(vec.x, vec.y));
    }

    // Return true if the center noise int should be changed for compatibility
    private bool ShouldChangeCenterNoiseInt(List<int> noiseInt3x3)
    {
        int centerNoise = noiseInt3x3[4];
        if (
                // check if no neighbors on top and bottom
                (noiseInt3x3[1] < centerNoise && noiseInt3x3[7] < centerNoise)
                ||
                // check if no neighbors left and right
                ( noiseInt3x3[3] < centerNoise && noiseInt3x3[5] < centerNoise)
                ||
                // check if neighbor tiles are diagonal
                (
                     (
                       noiseInt3x3[1] == centerNoise && noiseInt3x3[3] == centerNoise &&
                       noiseInt3x3[5] == centerNoise && noiseInt3x3[7] == centerNoise
                     )
                     &&
                     (
                      ( noiseInt3x3[0] < centerNoise && noiseInt3x3[8] < centerNoise )
                      ||
                      ( noiseInt3x3[2] < centerNoise && noiseInt3x3[6] < centerNoise )
                     )
                )
                ||
                // check for bridge cases
                (
                    (noiseInt3x3[0] < centerNoise && noiseInt3x3[5] < centerNoise && noiseInt3x3[7] < centerNoise)
                    ||
                    (noiseInt3x3[2] < centerNoise && noiseInt3x3[3] < centerNoise && noiseInt3x3[7] < centerNoise)
                    ||
                    (noiseInt3x3[6] < centerNoise && noiseInt3x3[1] < centerNoise && noiseInt3x3[5] < centerNoise)
                    ||
                    (noiseInt3x3[8] < centerNoise && noiseInt3x3[1] < centerNoise && noiseInt3x3[3] < centerNoise)
                )
           )
            return true;

        return false;
    }

    // If there is a neighbor with a different noise int, it is returned, else return center noise int
    private int GetNearbyNoiseInt(List<int> noiseInt3x3)
    {
        int centerNoiseInt = noiseInt3x3[4];
        foreach (int neighborNoiseInt in noiseInt3x3)
        {
            if (centerNoiseInt != neighborNoiseInt)
            {
                return neighborNoiseInt;
            }
        }
        return centerNoiseInt;
    }
    
    #endregion
    */

}
