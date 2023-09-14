using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Tilemaps;

public class TerrainAssets : MonoBehaviour
{
    #region Tilemaps
    [SerializeField] private Tilemap nonBlockingTerrainTilemap;
    [SerializeField] private Tilemap blockingTerrainTilemap;
    #endregion

    #region Grass Tile List
    [SerializeField] private List<Tile> grassTiles;
    #endregion

    private Dictionary<string, Tile> tileRules;


    public void InitializeTileRules()
    {
        tileRules = new()
        {
            { "=========", grassTiles[0] },
            { ""}
        };
    }

    // Clears all tiles from tilemaps
    public void ClearAllTiles()
    {
        nonBlockingTerrainTilemap.ClearAllTiles();
        blockingTerrainTilemap.ClearAllTiles();
    }
    /*
    // Erases the given chunk from the tilemaps
    public void DeleteChunk(Chunk chunk)
    {
        Vector3Int vec3 = new(gridTile.vector.x, gridTile.vector.y, 0);
        nonBlockingTerrainTilemap.SetTile(vec3, null);
        blockingTerrainTilemap.SetTile(vec3, null);
    }
    */

    public Tile GetTile(int[,] localHeights)
    {

        return null;
    }

    private void RenderTile(Chunk chunk, Vector2Int pos)
    {

    }

    // Renders the given chunk
    public void RenderChunk(Chunk chunk)
    {

        // nonBlockingTerrainTilemap.SetTile(vec3, gridTile.transTile);
        // blockingTerrainTilemap.SetTile(vec3, gridTile.transTile);
    }

}
