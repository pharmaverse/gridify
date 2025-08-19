---
title: "UML Graph"
output: html_document
---

## Overview

The main intention of this UML diagram is to introduce and facilitate understanding of the design behind the
`gridify` package. 
The package is using the <a href="https://adv-r.hadley.nz/s4.html" target="_blank">S4 system in R</a>, 
implementing Object Oriented Programming, where new object types are created to modularize and streamline
their interactions. 
The UML graph shows how these new objects are designed: what their components are and the methods through which
they interact.

We can refer to the two essential R files that contribute to the implementation of the `gridify` system:

-   `R/gridify-classes.R`: Contains the class definitions for the core components, including their properties and methods.

-   `R/gridify-methods.R`: Implements the methods and functionality associated with the various classes.

## Purpose

The primary purpose of this design is to provide a flexible and organized approach to creating and managing outputs in a
graphical interface. 
The `gridifyClass` serves as the central hub, holding a layout and managing titles, subtitles, footnotes, and other text elements around the output. 
The `gridifyLayout` defines the arrangement and spacing of the object and cells, while `gridifyCells` and `gridifyCell`
handle the detailed positioning and configuration of individual output components.
This modular structure ensures that outputs can be easily arranged, adjusted, and displayed according to the specified 
layout parameters. 
Our design philosophy prioritizes composition over inheritance, promoting flexibility and maintainability.

#### See below the code for gridify UML Graph:

Copy and paste the code below to <a href="https://mermaid.live" target="_blank">Mermaid Live Editor</a> to view it as a UML graph.

The top section of each box shows the values an object of that class contains, the bottom section (if any) shows the functions associated with that class of object.

``` mermaid
classDiagram
    class gridifyClass {
        +grob: grob
        +layout: gridifyLayout
        +elements: list
        +set_cell()
        +print()
        +show_cells()
        +show_spec()
        +show_layout()
        +show()
        +export_to()
    }
    class gridifyLayout {
        +nrow:numeric
        +ncol: numeric
        +heights: unit
        +widths: unit
        +margin: unit
        +global_gpar: gpar
        +background: character
        +adjust_height: logical
        +object: gridifyObject
        +cells: gridifyCells
        +show_cells()
        +show_spec()
        +show_layout()
        +show()
    }
    
    class gridifyObject {
        +row: numeric
        +col: numeric
        +height: numeric
        +width: numeric
    }
    class gridifyCells {
        cells: namedList[gridifyCell]
    }
    class gridifyCell {
        +row: numeric
        +col: numeric
        +text: character
        +mch: numeric
        +x: numeric
        +y: numeric
        +hjust: numeric
        +vjust: numeric
        +rot: numeric
        +gpar: gpar
    }
    
    gridifyClass --* gridifyLayout: contains
    gridifyLayout --* gridifyCells: contains
    gridifyLayout --* gridifyObject: contains
    gridifyCells --* gridifyCell: contains
```
