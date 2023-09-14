using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player : MonoBehaviour
{
    [SerializeField] TerrainGenerator terrainGenerator;

    private BoxCollider2D boxCollider;
    private Vector3 moveDelta;
    private RaycastHit2D hit;

    private Vector2Int prevPlayerPos;
    private Vector2Int currPlayerPos;

    private void Start()
    {
        boxCollider = GetComponent<BoxCollider2D>();
        InitializePlayerPositions();
    }

    private void FixedUpdate()
    {
        HandleMovement();
        CheckPlayerMovement();
    }

    void InitializePlayerPositions()
    {
        prevPlayerPos.x = (int)(transform.position.x / 0.16f);
        prevPlayerPos.y = (int)(transform.position.y / 0.16f);

        currPlayerPos.x = (int)(transform.position.x / 0.16f);
        currPlayerPos.y = (int)(transform.position.y / 0.16f);
    }
    
    
    void CheckPlayerMovement()
    {
        currPlayerPos.x = (int)(transform.position.x / 0.16f);
        currPlayerPos.y = (int)(transform.position.y / 0.16f);
        /*
        if (prevPlayerPos.x != currPlayerPos.x)
        {
            if (prevPlayerPos.x < currPlayerPos.x)
                terrainGenerator.MoveGridEast();
            else
                terrainGenerator.MoveGridWest();

            prevPlayerPos.x = currPlayerPos.x;
        }
        if (prevPlayerPos.y != currPlayerPos.y)
        {
            if (prevPlayerPos.y < currPlayerPos.y)
                terrainGenerator.MoveGridNorth();
            else
                terrainGenerator.MoveGridSouth();

            prevPlayerPos.y = currPlayerPos.y;
        }
        */
    }
    

    void HandleMovement()
    {
        float x = Input.GetAxisRaw("Horizontal");
        float y = Input.GetAxisRaw("Vertical");

        // Reset MoveDelta
        moveDelta = new Vector3(x, y, 0);

        // Swap sprite direction, whether you're going right or left
        if (moveDelta.x > 0)
            transform.localScale = Vector3.one;
        else if (moveDelta.x < 0)
            transform.localScale = new Vector3(-1, 1, 1);

        // Make sure we can move in this direction, by casting a box there first, if the box returns null, we're free to move
        hit = Physics2D.BoxCast(transform.position, boxCollider.size, 0, new Vector2(0, moveDelta.y),
            Mathf.Abs(moveDelta.y * Time.deltaTime), LayerMask.GetMask("Actor", "Blocking"));

        if (hit.collider == null)
        {
            // Make this thing move!
            transform.Translate(0, moveDelta.y * Time.deltaTime, 0);
        }

        // Make sure we can move in this direction, by casting a box there first, if the box returns null, we're free to move
        hit = Physics2D.BoxCast(transform.position, boxCollider.size, 0, new Vector2(moveDelta.x, 0),
            Mathf.Abs(moveDelta.x * Time.deltaTime), LayerMask.GetMask("Actor", "Blocking"));

        if (hit.collider == null)
        {
            // Make this thing move!
            transform.Translate(moveDelta.x * Time.deltaTime, 0, 0);
        }
    }

}
