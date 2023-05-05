using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HighlightContoller : MonoBehaviour
{

    public Material Material;
    public Transform Transform;
    public float Z;
    public ColorTag Tag;
    public bool UseCanvasPosition;
    public Camera Camera;

    private void OnValidate()
    {
        
        GameObject go = GameObject.FindWithTag(Tag.ToString());
        if (go != null)
        {
            if (UseCanvasPosition)
            {
                HighlightCanvasTransform(go.transform);
            }
            else
            {
                HighlightTransform(go.transform);
            }
        }
    }

    public void HighlightTransform(Transform transform)
    {
        Vector3 worldPos = transform.position;
        Material.SetVector("_HighlightAreaCenter", worldPos);
    }
    
    public void HighlightCanvasTransform(Transform transform)
    {
        Vector3 worldPos = Camera.main.ScreenToWorldPoint(new Vector3(transform.localPosition.x, transform.localPosition.y, Z));
        Material.SetVector("_HighlightAreaCenter", worldPos);
    }
}

[Serializable]
public enum ColorTag
{
    green,
    red,
    blue,
    pink
}