# Formal Mathematics Library Visualizer

## Overview

This GitHub Action automatically generates interactive visualizations for formal mathematics libraries written in **Agda**.

Designed to integrate seamlessly into CI/CD pipelines, the tool performs the following steps:
1.  **Environment Setup**: runs within a Docker container with pre-configured compilers (Agda, GHC) and Python dependencies.
2.  **Compilation**: Type-checks the library and generates structural data (e.g., Agda S-expressions).
3.  **Processing**: Parses the module dependencies and definitions to construct a directed graph.
4.  **Visualization**: Outputs web-ready assets (interactive graphs, standalone HTML, or embeddable components) that can be deployed directly to GitHub Pages.

## Result

You can view a live example of the visualization generated for the **Agda Unimath** library here:

[**https://unimath.github.io/agda-unimath/VISUALIZATION.html**](https://unimath.github.io/agda-unimath/VISUALIZATION.html)
