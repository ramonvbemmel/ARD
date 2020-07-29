using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour
{
    private Rigidbody rb;
    private Camera cam;
    void Start()
    {
        rb = GetComponent<Rigidbody>();
        cam = Camera.main;
    }
    void FixedUpdate()
    {
        //Get mouse x position
        float mouseX = Input.mousePosition.x;
        //get mouse y position
        float mouseY = Input.mousePosition.y;
        //Convert the screenpostion to x/y position 
        Vector3 mousePos = cam.ScreenToWorldPoint(new Vector3(mouseX, mouseY, cam.nearClipPlane + 10));
        //Make position global
        Shader.SetGlobalFloat("_X_AS", mousePos.x);
        Shader.SetGlobalFloat("_Y_AS", mousePos.y);
        //update the position
        rb.position = mousePos;
    }
}
