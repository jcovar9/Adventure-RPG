using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Tilemaps;

public class TerrainWalker : MonoBehaviour
{

    [SerializeField] private NoiseGenerator noise;
    [SerializeField] private TerrainAssets terrain;

    private int x;
    private int y;

    #region Neighbor Fields
    private float NorthWest; private float North;  private float NorthEast;

    private float West;      private float Center; private float East;

    private float SouthWest; private float South;  private float SouthEast;
    #endregion


    private int currBiomeInt;
    private int nearBiomeInt;


    public Vector2Int GetWalkerCoords()
    {
        return new Vector2Int(x, y);
    }


    public void SetWalker(int x_coord, int y_coord)
    {
        x = x_coord;
        y = y_coord;

        NorthWest = noise.GetNoiseValue(x - 1, y + 1);
        North     = noise.GetNoiseValue(x    , y + 1);
        NorthEast = noise.GetNoiseValue(x + 1, y + 1);

        West      = noise.GetNoiseValue(x - 1, y    );
        Center    = noise.GetNoiseValue(x    , y    );
        East      = noise.GetNoiseValue(x + 1, y    );

        SouthWest = noise.GetNoiseValue(x - 1, y - 1);
        South     = noise.GetNoiseValue(x    , y - 1);
        SouthEast = noise.GetNoiseValue(x + 1, y - 1);
    }



    #region Walker Movement
    public void MoveNorth()
    {
        y += 1;

        SouthWest = West;
        South = Center;
        SouthEast = East;

        West = NorthWest;
        Center = North;
        East = NorthEast;

        NorthWest = noise.GetNoiseValue(x - 1, y + 1);
        North = noise.GetNoiseValue(x, y + 1);
        NorthEast = noise.GetNoiseValue(x + 1, y + 1);
    }

    public void MoveEast()
    {
        x += 1;

        NorthWest = North;
        West = Center;
        SouthWest = South;

        North = NorthEast;
        Center = East;
        South = SouthEast;

        NorthEast = noise.GetNoiseValue(x + 1, y + 1);
        East = noise.GetNoiseValue(x + 1, y);
        SouthEast = noise.GetNoiseValue(x + 1, y - 1);
    }

    public void MoveSouth()
    {
        y -= 1;
        
        NorthWest = West;
        North = Center;
        NorthEast = East;

        West = SouthWest;
        Center = South;
        East = SouthEast;

        SouthWest = noise.GetNoiseValue(x - 1, y - 1);
        South = noise.GetNoiseValue(x, y - 1);
        SouthEast = noise.GetNoiseValue(x + 1, y - 1);
    }


    public void MoveWest()
    {
        x -= 1;

        NorthEast = North;
        East = Center;
        SouthEast = South;

        North = NorthWest;
        Center = West;
        South = SouthWest;

        NorthWest = noise.GetNoiseValue(x - 1, y + 1);
        West = noise.GetNoiseValue(x - 1, y);
        SouthWest = noise.GetNoiseValue(x - 1, y - 1);
    }
    #endregion

}
