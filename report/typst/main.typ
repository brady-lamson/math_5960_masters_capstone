// #import "@preview/grape-suite:4.0.0": seminar-paper
// #import seminar-paper:

#import "grape-suite-4.0.0/src/seminar-paper.typ" as seminar-paper
#show figure.caption: set text(style: "italic")

#show: seminar-paper.project.with(
    title: "Small Area Estimation with the Fay-Herriot Model",
    subtitle: "",
    abstract: include "abstract.typ",

    university: [University of Colorado Denver],
    instructor: none,
    faculty: none,
    institute: none,
    // seminar: none,

    submit-to: none,
    submit-by: none,

    semester: [Fall 2026],
    date-format: date => date.display("[month repr:long] [day], [year]"),

    author: "Brady Lamson",
    email: "brady.lamson@ucdenver.edu",
    address: none,
    show-declaration-of-independent-work: false
)

#set math.equation(block: true, numbering: "(1)")

#include "intro/intro.typ"
#include "data/data.typ"
#include "methods/methods.typ"
#include "results/results.typ"
#include "conclusion/conclusion.typ"
#bibliography("references.bib")
#include "appendix/appendix.typ"
