#import "template.typ": *
#import "@preview/codelst:2.0.1": sourcecode

#set outline(title: "Table of contents")

#show: bubble.with(
  title: "Warthog Network",
  subtitle: "Rethinking the Blockchain",
  alt: "Whitepaper",
  affiliation: "University",
  date: datetime.today().display(),
  //main-color: "4DA6FF",
  logo: image("./assets/SVGs/Circle/Warthog_2024_Circle Yellow.svg"),
  color-words: ("highlight", "important")
) 
#outline()

#pagebreak()


= Introduction

This is a simple template that can be used for a report.


= Features
== Colorful items

The main color can be set with the `main-color` property, which affects inline code, lists, links and important items. For example, the words highlight and important are highlighted !

- These bullet
- points
- are colored

+ It also
+ works with
+ numbered lists!

== Customized items


Figures are customized but this is settable in the template file. You can of course reference them @ref.

#figure(caption: [Source tree], kind: image,
box(width: 65%,sourcecode(numbering:none,
```bash
main
├── README.md
├── assets
│   ├── images
│   │   ├── used images
│   └── backup 
│       └── backup files
├── makefile
└── src
    ├── headers
    │   ├── files.h
    └── files.c
```))
)<ref>

#pagebreak()

= Enjoy !

#lorem(100)
