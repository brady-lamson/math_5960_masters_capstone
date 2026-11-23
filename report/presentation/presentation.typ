// Local import so I can modify slide header font size
#import "../diatypst/0.10.1/lib.typ" as diatypst
// #import "@preview/diatypst:0.10.1": *
#show figure.caption: set text(style: "italic")
#set outline(depth: 1)
#let cu_gold = "#CFB87C" // From official brand styling
// https://cdn.brandfolder.io/KTQPL4IM/at/tr63rjmxjtm5cg98b94p9p9/CUDenver_BrandBook_2023_85x14-Digital-Pages-Links_MA_Final.pdf#page=62



#show: diatypst.slides.with(
    title: "Small Area Estimation with the Fay-Herriot Model", 
    subtitle: "A Bayesian Approach to Spatial Small Area Estimation.",
    date: "Fall 2026",
    authors: ("Brady Lamson"),
    logo: read("cu_logo.png", encoding: none),
    title-color: rgb(cu_gold),
    footer-title: "Fay-Herriot Small Area Estimation",
    footer-subtitle: "Bayesian FH with Spatial Random Effects",
    // count: "dot-section",
    count: "number", // alternatives: 'dot', 'dot-section'
    layout: "medium",
    theme: "full",
    // ratio: 4/3
)

#include "intro/intro.typ"
#include "data/data.typ"
#include "methods/methods.typ"
#include "results/results.typ"
#include "conclusion/conclusion.typ"
#include "appendix/appendix.typ"

= Bibliography
== Bibliography
#text(size: 8pt)[#bibliography("../paper/references.bib")]
