#import "@preview/diatypst:0.10.1": *
#show figure.caption: set text(style: "italic")
#set outline(depth: 1)
#show: slides.with(
    title: "Small Area Estimation with the Fay-Herriot Model", 
    subtitle: "A Bayesian Approach to Spatial Small Area Estimation.",
    date: "Fall 2026",
    authors: ("Brady Lamson"),
    logo: read("cu_logo.png", encoding: none),
    title-color: rgb("#CFB87C"),
    footer-title: "Fay-Herriot Small Area Estimation",
    footer-subtitle: "Bayesian FH with Spatial Random Effects",
    count: "dot-section",
    layout: "medium",
    theme: "full"
)

#include "intro/intro.typ"
#include "data/data.typ"
#include "methods/methods.typ"
#include "results/results.typ"
#include "conclusion/conclusion.typ"
#include "appendix/appendix.typ"