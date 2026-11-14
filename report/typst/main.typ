// #import "@preview/grape-suite:4.0.0": seminar-paper
// #import seminar-paper:

#import "grape-suite-4.0.0/src/seminar-paper.typ": seminar-paper
#show figure.caption: set text(style: "italic")

#show: seminar-paper.project.with(
    title: "Small Area Estimation with the Fay-Herriot Model",
    subtitle: "",

    university: [University of Colorado Denver],
    faculty: none,
    institute: none,
    seminar: none,

    submit-to: none,
    submit-by: none,

    semester: [Fall 2026],

    author: "Brady Lamson",
    email: "brady.lamson@ucdenver.edu",
    address: none,
    show-declaration-of-independent-work: false
)

#set math.equation(block: true, numbering: "(1)")

#include "abstract.typ"
#pagebreak()
#include "intro/intro.typ"
#include "data/data.typ"
#include "methods/methods.typ"
#include "results/results.typ"
#include "conclusion/conclusion.typ"
#bibliography("references.bib")
#include "appendix/appendix.typ"

///Users/brady_fingoal/Library/Caches/typst/packages/preview/grape-suite/4.0.0/src/seminar-paper.typ