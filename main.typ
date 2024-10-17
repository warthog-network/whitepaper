#import "template.typ": *
#import "@preview/codelst:2.0.1": sourcecode

#set outline(title: "Table of contents")

#let emission = csv("files/emission_scheme.csv")

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


= Introduction and Project goals

Warthog is a classical Proof-of-Work (PoW) based cryptocurrency which is meant to be a fun and experimental side project of its developers Pumbaa, Timon and Rafiki who work in blockchain industry.

We are working on Warthog in our free time and there is always the risk that we leave due to time constraints or personal reasons. In fact our colleague Timon has already left the team. Therefore we are trying to build up a strong community backing the project.

Mainly one can describe this project as an experiment to try out new things and learn how blockchain technology works in detail. But at the same time we want to be as transparent and fair as possible and avoid as much as possible fishy and questionable practice currently seen in most other new projects.

The code is freshly written in C++20 and is not a cheap fork of any other project. Therefore there is always the risk of serious or unfixable bugs. But at the same time there is real effort put into this project which sets it apart from most competitors.

The community is welcome to take actively part in the evolution of Warthog, the logo and the explorer are made by volunteers and also possible choices for a mining algorithm are proposed. The connection with the community shall be preserved and extended in the future. If you want to join, please do so!

There is no specific purpose or use case of Warthog. However we want to revive the days when crypto was a fun and an interesting experimental thing. One of our experiments with this project is to use SQLite to store blocks and state. Another is the completely novel idea of syncing nodes via chain descriptors instead of asking other nodes for blocks by their hashes.

One design principle of Warthog is fast sync speed and a low impact on system resources which is achieved by the use of fast hashing algorithms, appropriate data structures and our custom-built sync algorithm.

For now and in the near future the primary plan is to make the node implementation more robust and improve infrastructure like explorer and API for better interoperability.


= Technical Details
== Retarget Logic
Similarly to Bitcoin, the warthog blockchain will scale its difficulty periodically to adjust for changing hashrate. Changes in difficulty is partitioned into two phases:

    In the initial phase the difficulty is adjusted every 720 blocks which corresponds to approximately 4 hours.
    In the second phase the difficulty is adjusted every 8640 blocks which corresponds to 2 days.

The reason for this two-phase approach is the high variability of hashrate in early stages of a project's life which initially requires a more frequent difficulty adjustment. On the other hand too short intervals also have disadvantages such as the tendency to oscillate and a possibly higher impact of faked timestamps. Therefore the second phase stretches the difficulty adjustment interval after the initial phase.

While in Bitcoin the difficulty change is capped by factor 4, we have implemented a factor 2 cap because our difficulty adjustment is more frequent than 2 weeks.

== Emission Scheme

Warthog was started without any premined or reserved amount of coins on June 29, 2023. The project implements a classical halving-based emission scheme with halvings occurring every 3153600 blocks (every 2 years). The emission for the next 4 years is summarized in the following table:

#table(columns: 3, table.header([Date], [Lifetime], [% of total supply in circulation]))


There is no tail emission which means there is a hard cap of the amount in circulation. The hard cap is 18921599.68464 WART (around 19 million coins).

Before halving occurs every block yields 3 WART as miner reward. Since the block time is 20 seconds, every day approximately 60/20 × 60 × 24 = 4320 blocks and 12960 WART are mined before halving.
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
