#import "template.typ": *
#import "@preview/codelst:2.0.1": sourcecode
#import "@preview/cheq:0.2.2": checklist

#set outline(title: "Table of contents", indent: 1em)

#let emission = csv("files/emission_scheme.csv")

#show: bubble.with(
  title: "Warthog Network",
  subtitle: "Rethinking the Blockchain",
  alt: "Whitepaper",
  affiliation: "University",
  date: datetime.today().display(),
  logo: image("./assets/logo/Circle/Warthog_2024_Circle Yellow.svg"),
  color-words: ()
) 
#outline()

#pagebreak()

#show: checklist

= Introduction

== History
Originally, Warthog was written as a fun and experimental side project of its original developers Pumbaa, Timon and Rafiki has who work in blockchain industry. Initially there was no specific purpose or use case planned. Instead, the goal was firstly to revive the days when crypto was a fun and an interesting experiment, and secondly to try out new things and learn how blockchain technology works in detail.

However soon after its inception a vibrant community started to form around the young project and with it new contributors joined the project bringing a fresh wind of development support and innovative ideas. The project started to grow up and is still growing today.

== What is Warthog Network?

Warthog is the first *Proof-of-Balanced-Work* (PoBW) Layer 1 network trying to push the boundary of what is technically possible by implementing multiple *highly innovative* and unique features including


- Janushash (first anti-farm balanced CPU/GPU combo PoBW algo)
- Chain descriptor sync (new efficient and resource-friendly sync)
- SQLite blockstore (easy cross-platform copy of chain file)
- Full browser nodes (start a full node by opening a website)
- WasmFS support (browser nodes can persist whole chain)
- WebRTC support (browser nodes can communicate P2P)

Unlike may other cryptocurrency projects we are *not a fork* of any other project. Instead, the *code is freshly written* in the #box[C++] programming language. New software always bears the risk of unforeseen bugs but at the same time the real effort put into this project sets it apart from most competitors.

As a community project we are trying to be as transparent and fair as possible and avoid the fishy and questionable practice currently seen in most other new projects: we had a *fair launch* with *no team allocation or premine*, therefore donations for developments are always welcome!

Warthog is neither a company nor an organization. It is rather a loose team of passionate crypto enthusiasts who are contributing to the project in their free time. Bear in mind that team members may decide to leave the project at any time, in fact Timon, one of the original developers has already left the team. 

Therefore we are constantly trying to expand the stronger community behind Warthog.
The community is welcome to take actively part in the evolution of Warthog. The logo, the explorer and other milestones were contributed by volunteers. If you think you can help, please let us know! 

= Revolutionary features

There are several noatable features that are exclusive to Warthog across the industry. 
@janushash

= Browser nodes

#block[
#set text(size: 0.9em)
#emph[Note:] Browser nodes are technically advanced but currently on hold. DeFi features have top priority and implementation will resume after DeFi is fully shipped.
]

Warthog introduces the ability to run a full blockchain node directly within a web browser, a feat accomplished through WebAssembly compilation of the native C++ node code. This breakthrough enables anyone to participate in the network by simply opening a web page, without requiring software installation or manual configuration. The browser node implementation represents a fundamental shift in accessibility for blockchain participation.

== WasmFS

The WebAssembly File System (WasmFS) enables browser-based nodes to persist the entire blockchain state locally within the browser's storage. Unlike traditional web applications which are stateless by design, WasmFS provides a virtual filesystem that survives page reloads and browser restarts. This persistence is crucial for a blockchain node, as synchronization must be maintained across sessions. Through WasmFS, browser nodes can store the complete chain database, enabling true full-node functionality without server-side components. The implementation leverages OPFS (Origin Private File System) to achieve reliable writes and reads of binary blockchain data.

== P2P communication over WebRTC
P2P communication between Browsers is possible via the WebRTC protocol. This protocol has to be signaled on connection establishment, i.e. a service needs to perform negotiation work before both ends are connectd directly. Nodes themselves will be configured to do this such that no external services will be necessary apart from being connected to the Warthog network.
= DeFi2 
We will hard-code DeFi within Warthog nodes. On the one hand this puts additional burden on core developers because DeFi code must be written instead of leaving this task for smart contract developers. But on the other hand it yields several advantages and extends DeFi possibilities:
- Unified and systematic treatment of DeFi and assets 
- No Service fragmentation like countless swap service clones 
- No unfair practices for scammers like additional fees or supply inflation hidden behind smart contract logic.
- Clear foundation to check how each token was initially distributed (Fair auction or just minted out of thin air)
- Custom matching engine to *solve MEV extraction issue* that plagues DeFi, see @matching_engine.
- Additional features such as *clone balance distribution*, *dividends*, *scriptless airdrops*.
We call this concept and its extended capabilities _DeFi2.0_.
== Custom Matching engine
<matching_engine>

=== The Problem with Sequential Matching

In traditional DeFi protocols, swap orders are matched against liquidity pools one at a time. Each transaction interacts with the pool sequentially, which means the pool state changes after every individual swap. This creates an ordering dependency that block builders can exploit: by observing pending transactions in the mempool, they can position their own orders before or after a victim's order to extract value. This practice, known as MEV extraction, manifests most commonly as sandwich attacks where a victim's trade is surrounded by attacker transactions that buy low and sell high at the victim's expense.

=== Fair Batch Matching: The Solution

Warthog's custom matching engine implements *Fair Batch Matching* (FBM), a mathematical framework that processes all swap orders within a block jointly rather than sequentially #cite(<fairbatchmatching>). This approach completely eliminates the possibility of ordering-based MEV extraction.

A swap order is represented as a pair $(l, q)$ where $l$ is the limit price and $q$ is the swap quantity. The order book consists of base swap orders (sell orders) and quote swap orders (buy orders). The liquidity pool maintains reserves of the base asset and the quote asset.

For a given price $p > 0$, a valid *fill configuration* assigns fill quantities to each order such that sell orders with limit price below $p$ are filled, buy orders with limit price above $p$ are filled, and at most one order can be partially filled. The fill sums $F^B$ and $F^Q$ represent the total base and quote asset quantities to be exchanged.

A *pool interaction* is a pair satisfying the constant product equation $(q^B + Delta^B)(q^Q + Delta^Q) = q^B q^Q$, where $q^B$ and $q^Q$ are the pool's base and quote reserves, and $Delta^B$ and $Delta^Q$ represent the changes in these reserves due to the interaction.

A pool interaction is deemed *fair* when neither buyers nor sellers can improve their average conversion price by interacting differently with the pool. This occurs when the pool price equals the ratio of fill sums, or when one side fully utilizes the pool while the other does not.

A *Fair Batch Matching (FBM)* consists of a price $p$, a corresponding valid fill configuration, and a fair pool interaction with final pool price $p = (q^Q + Delta^Q) / (q^B + Delta^B)$.

*Theorem (Fair Batch Matching).* There always exists a unique Fair Batch Matching for any order book and liquidity pool configuration. This guarantees that all participants receive the same fair price for their trades.

This theorem, proven in #cite(<fairbatchmatching>), establishes that FBM is the canonical and only fair method for matching discrete liquidity (order books) with continuous liquidity (liquidity pools). The uniqueness property means that no participant can obtain a better price by manipulating transaction ordering, effectively rendering sandwich attacks impossible at the consensus level.

== New DeFi features

Warthog's hard-coded DeFi implementation enables novel features that are difficult or impossible to realize in smart contract-based systems. These features leverage the node's native understanding of token balances and transaction flow.

=== Balance Cloning

Balance cloning enables the creation of new tokens whose initial distribution mirrors an existing token's balance. This is achieved through a lazy copy-on-write database mechanism that references the original token's UTXO set without immediately duplicating data. When a cloned token is created, all holders of the original token receive an identical balance of the new token. This feature enables use cases such as testnet token distribution (distributing a snapshot of mainnet balances on a test environment) and community-driven token forks where the entire holder distribution is preserved. The copy-on-write approach ensures efficiency: storage is only consumed when a cloned token holder makes their first transaction, diverging from the original distribution.

=== Paying Dividends to Holders

Warthog's architecture natively supports dividend distribution, allowing token issuers to distribute rewards proportionally to all token holders without requiring manual claims. When a dividend distribution transaction is processed, the node automatically computes each holder's proportion of the total supply and transfers the appropriate reward amount. This mechanism operates entirely at the consensus level, eliminating the need for smart contract registries or merkle tree-based claim systems. Dividend distributions are transparent and verifiable: every account balance update is recorded on-chain, and the distribution math is enforced by the matching engine rather than trusted off-chain computation.

=== Scriptless Airdrops

Traditional airdrops require either large merkle trees for distribution proofs or expensive individual transactions for each recipient. Warthog's scriptless airdrop mechanism instead creates new tokens and simultaneously distributes them to all holders of an existing token through a single transaction. The creator specifies a source token and a ratio determining how many new tokens each holder of the source token receives. The node's copy-on-write system efficiently creates the new token balances while the transaction fee is paid only once by the airdrop creator. This approach makes bulk token distribution economically viable even for large holder sets, as the cost scales with the number of distinct balance changes rather than the total number of holders.


== Orderbook Surface Propagation (Later)
<SurfacePropagation>
At a later stage we will focus on implementing a new method to lower order fees. Nodes can inspect order prices and only share orders from their mempools which have better buy/sell price than what peers know. This way only the surface of the order book is transmitted between nodes up to the point where buy and sell overlap, i.e. where order matching is possible. This idea shall be more elaborated at a later stage.

= Janushash
<janushash>


== Proof of Balanced Work

=== Introduction

Proof of Balanced Work (PoBW) was first formulated in 2023 by Warthog community developer "CoinFuMasterShifu"  #cite(<pobw>) and was specifically implemented for Warthog for the first time. Compared to classical Proof of Work, the class of Proof of Balanced Work (PoBW) algorithms is very different. Instead of only employing one hash function they combine multiple hash functions in a multiplicative way. The mathematical theory of considering a multiplicative combination of hashes, i.e. hash products, was established in this paper for Warthog and currently there is no other crypto project using Proof of Balanced Work for consensus.

Combining different hash functions multiplicatively has the advantage that

+ different hash functions can be mined in parallel devices at different hashrates using a multi-stage filtering approach and
+ efficient mining requires mining of all involved algorithms for each block in contrast to previous failed attempts to construct multi-algorithm block chains by using individual difficulties for each algorithm (Myriad Coin, DigiByte, Verge). For example Verge was hacked by focusing only on one algorithm.


== Janushash

Essentially, Proof of Balanced Work algorithms are simply the multiplicative combinations of existing hash functions. Warthog's Janushash algorithm combines two hash functions:

+ triple Sha256 (Sha256t) and
+ Verushash v2.2


=== Balancing

Energy-efficient mining of Proof of Balanced Work algorithms requires finding a good balance between Sha256t and Verushash hashrates. The best combination depends on hardware and energy cost but it is clear that mining without a GPU or with a weak CPU won't be competitive. The balancing requirement coined the name "Proof of Balanced Work".

== Hashrate Decentralization

=== Fighting Farms

Interestingly, the Janushash algorithm keeps away both, GPU farms and CPU farms:

GPU farms usually save on the CPU side, because CPU performance is not relevant for mining GPU algorithms. Therefore such farms perform poorly on Janushash. GPU farm owners would need to make significant investments in efficient and performant motherboards and CPUs to improve their GPU/CPU balance for efficiently mining Janushash.

CPU farms perform very poorly on Janushash because of the lack of accelerated triple Sha256 hash evaluation. The same applies to most botnets.

This means large mining farms and botnets play a much smaller role in Warthog than they do in other proof of work cryptocurrencies, which increases decentralization of hashrate.

=== Satoshi's vision

Originally, Satoshi Nakamoto had an idealized hope for mining being a democratized way of establishing consensus. This can be seen for example in his famous whitepaper #cite(<nakamoto2009bitcoin>) where it says:
#blockquote[Proof-of-work is essentially one-CPU-one-vote.]

From this article #cite(<lazlogpu>) about Laszlo Hanyecz's correspondence with Satoshi we can observe that Satoshi was not amazed about the fact that GPU mining would disrupt this idealized hope:

#blockquote[One of the first emails Satoshi had sent the man was in response to him describing his proposed GPU miner. Mainly, Satoshi was none-too-pleased, asking Hanyecz to slow down with this.]
#blockquote[Satoshi explained that, at the time, one of the biggest attractions possible is the fact that anyone can download Bitcoin and start mining with their laptops. Without that, it wouldn't have gained as much traction.]


He knew that with the advent of GPU mining, many CPU miners would be kicked out of the network, which would be against his vision of fair, equal and decentralized mining. Therefore he hoped to delay this as long as possible. @bitcointalk shows one of his posts on Bitcointalk.
#figure(
  image("./assets/satoshi_bitcointalk.png", width: 80%),
  caption: [Satishi's hope to postpone GPU arms race.],
)<bitcointalk>


We all know that his hopes have not been fulfilled, today Bitcoin is mined on specialized expensive hardware and only those with access to this hardware can participate in mining. After all, Satoshi was not able to solve the issue of centralized mining.

We are confident that the use of Proof of Balanced Work solves this issue to a large extent when the combined hash functions are carefully selected. In Janushash, the two hash functions Sha256t and Verushash where chosen to require a GPU and a CPU connected with sufficiently large bandwidth. This was done to target typical gaming PCs. As described above, with this choice farms cannot easily join the network without being forced to make additional investments just for mining Warthog. This democratizes mining and brings Warthog closer to Satoshi's vision.

== ASIC Resistance

As technology advances, so does specialized mining hardware, especially when potential profits are high. There is nothing that can be done against this fact. However there are three reasons why Warthog is more robust against ASIC threats than other PoW cryptocurrencies:

=== Inherited ASIC Resistance

When it comes to ASIC resistance, Proof of Balanced Work is stronger than its strongest ingredient. To accelerate mining, an ASIC would need to be able accelerate computation of all combined hash functions to avoid a bottleneck effect. In addition an ASIC would need enough bandwidth between the hardware sections computing different hash functions as well as calibration and tuning to optimize their intercommunication and coordination.

In particular, Janushash inherits ASIC-resistance from Verushash v2.2 which is currently mined on CPUs and GPUs, but not on FPGAs/ASICs, and the need to also require SHA256t hashrate makes Janushash even more ASIC-resistant.

=== Detection of suspicious hashrate

In traditional Proof of Work networks we only have one marker to analyze network hashrate, namely the network difficulty. It can be used to estimate the total hashrate of all miners in the network. However we cannot tell whether some actors use specialized hardware to gain an unfair advantage over normal miners.

Janushash however combines two hash functions and harnessing the probability theory and statistics, we can extract information about the Sha256t/Verushash hashrate ratio used to mine a block. This information is shown publicly in the blockchain explorer.

In addition to the network difficulty, this second marker provides useful information on the network hashrate: It allows to spot suspicious hashrate immediately. In Warthog it is much more difficult for ASICs to stay undetected because they must not only successfully mine blocks, but also mimic the hashrate ratio used by honest miners. This is another unique property of Proof of Balanced Work.

=== Simple Algorithm Adaption

The fundamental reason for the favorable properties of the Janushash algorithm is not the particular choice of the combined hash functions itself, but the choice to rely on Proof of Balanced Work to combine different hash functions multiplicatively. This means that if ASICs really join the network one day, we can simply exchange the combined hash functions, for example for Blake3 on GPU and RandomX on CPU, while preserving all the advantages listed here. Combining established hash functions allows the creation new algorithms fast while benefiting from their maturity and proven properties at the same time. This allows Warthog to adapt quickly when needed.

== Other Benefits

Warthog tries to revive the good old days when mining was fun. The unique properties of the Janushash algorithm help to achieve this goal:

=== Escaping one-dimensional mining boredom

In a way, traditional mining in cryptocurrency is one-dimensional, the goal is simply to find the best hardware for evaluating some hash function. In contrast, mining Warthog is two-dimensional: there are two hash functions Sha256t and Verushash v2.2, and both hashrates are relevant for the mining efficiency. This leads to much more versatile options and motivates miners to experiment with endless hardware setups. Vivid discussions about the best combinations bring Warthog mining to life.

=== Favoring the little guy

As explained above, established farms require substantial investments in order to mine Warthog efficiently and making such investment only for mining Warthog might not be reasonable for most farms.

On the other hand gamers usually have systems with modern platforms and CPUs paired with sufficiently good GPUs to mine Warthog efficiently. Since farms and botnets are less of a direct competitor in Warthog than they are in other Proof of Work cryptocurrencies, this will reflect in increased mining returns for the average gamer or miner, which will in turn contribute to Warthog's popularity.

= Technical Details
== Retarget Logic
Similarly to Bitcoin, the warthog blockchain will scale its difficulty periodically to adjust for changing hashrate. Changes in difficulty is partitioned into two phases:

  +  In the initial phase the difficulty is adjusted every 720 blocks which corresponds to approximately 4 hours.
  +  In the second phase the difficulty is adjusted every 8640 blocks which corresponds to 2 days.

The reason for this two-phase approach is the high variability of hashrate in early stages of a project's life which initially requires a more frequent difficulty adjustment. On the other hand too short intervals also have disadvantages such as the tendency to oscillate and a possibly higher impact of faked timestamps. Therefore the second phase stretches the difficulty adjustment interval after the initial phase.

While in Bitcoin the difficulty change is capped by factor 4, we have implemented a factor 2 cap because our difficulty adjustment is more frequent than 2 weeks.

== Emission Scheme

Warthog was started without any premined or reserved amount of coins on June 29, 2023. The project implements a classical halving-based emission scheme with halvings occurring every 3153600 blocks (every 2 years). The emission for the next 4 years is summarized in the following table:
#figure(
  caption: [Emission scheme],
  table(columns: 3, table.header([*Date*], [*Lifetime*], [*% of total supply in circulation*]), 
    ..for (.., Date,Lifetime, percent_emission) in emission {
        (Date,Lifetime, percent_emission)
    })
  )

There is no tail emission which means there is a hard cap of the amount in circulation. The hard cap is `18921599.68464 WART` (around 19 million coins).

Before halving occurs every block yields `3 WART` as miner reward. Since the block time is 20 seconds, every day approximately $60/20 × 60 × 24 = 4320$ blocks and `12960 WART` are mined daily before halving.

== Coin Precision

The reference implementation uses the C++ data type `uint64_t` for storing amounts of `WART`. This is a 64 bit unsigned integer. To represent fractions of a coin these values are interpreted in fixed point arithmetic with 8 digits precision. This means that `1 WART` is internally represented as `uint64_t` number with value 100000000. The smallest representable step is `0.00000001 WART` and represented as `uint64_t` number with value 1.

For easier integration all API endpoints return both, the `WART` amount as a string (like `"amount": "12.0"`), and the internal integer representation indicated with label "E8" (like `"amountE8": 1200000000`).

== One-of-a-kind chain descriptor based sync

This project is an experiment where the developers try out new things and push the boundary of what is possible in blockchain technology. We invented a completely unique and new way of syncing nodes which is not presently not known to the industry.

Traditionally during synchronization new nodes request block bodies identified by block hashes. The replying node has to look up the block body based on the hash and then sends it back.

In contrast we have invented a node communication protocol which works without block hashes for block body lookup. In our setup nodes keep track on fork heights with other nodes. A chain descriptor is used to identify a specific chain on the peer. When a node appends to its chain, the chain descriptor remains unchanged, however the current chain descriptor is increased when the consensus chain switches to a longer fork. Block bodies for previous chains are also kept for some time in case a peer requests them.

When syncing nodes request block bodies identified by a chain descriptor and a block range. This way we avoid overhead in communication and lookup.

== SQLite backed block store

SQLite is a battle-proven and well-established embedded SQL database engine. Warthog nodes use SQLite as their main storage engine for both, blocks and state. Nodes also index transactions and can provide basic blockchain explorer functionality directly via API thanks to SQLite.

SQLite databases are also portable across 32-bit and 64-bit machines and between big-endian and little-endian architectures such that chain snapshots can easily shared. Furthermore SQLite supports transactions which are essential for data integrity even in case of a power outage or node crash.

The default SQLite database file name used for the chain is `chain.db3` and can be configured via the `--chain-db` command line option

== Account based architecture

Warthog implements an account based architecture. This is similar to Ethereum and different from Bitcoin's UTXO model. Every account along with its balance is stored in the `State` table of the chain database. For efficiency reasons accounts are referred by their id: Every account is assigned a unique auto-incremented id value on first use. This makes blocks more space-efficient since a block id only requires 8 bytes of storage whereas an address would require 20 bytes.


== Fee specification

For efficiency and compactness transaction fees are encoded as 2-byte floating-point numbers (16 bits), where the first 6 bits encode the exponent and the remaining 10 bits encode a 11 bit mantissa starting with an implicit 1. This means that fee values cannot be `0` and are of lower precision than regular amount values which use 4 bytes. A fee of value of `0` specified on transaction generation will automatically transform into the minimal fee value of `0.0000001 WART`.

#pagebreak()


= Roadmap 2024 - 2025
- [x] New "herominers" pool support (please aim for pool decentralization)
- [/] Collect sufficient donation funds
- [/] New website with design by BalkyBot (logo designer)
- [/] Browser nodes
  - [x] Allow chain to be saved within browsers persistently in WASMFS.
  - [x] Port node code to Webassembly
  - [/] Browser Node GUI (started)
  - [/] Add new realtime API methods for browser nodes (started)
  - [x] Refactor network code to abstract away the communication layer (raw TCP, Websocket, WebRTC)
  - [x] Invent a robust protocol for exchangeing peers and negotiating (signaling) P2P WebRTC connections between nodes.
  - [/] Protocol implementation
  - [ ] Testing
- [x] DeFi2.0
  - [x] Implement custom matching engine with Fair Batch Matching
  - [x] Design database tables for modeling pools and cloning token balance with copy-on-write
  - [x] Implement new token generation with three token types (WART, Assets, Liquidity Tokens)
  - [x] Implement hard-coded pools with merged (liquidity + limit orders) matching
  - [x] Implement protocol for exchanging orders between nodes
  - [x] Change block structure to support order matching
  - [x] Implement client-side blockchain explorer

= Summary
In this whitepaper we have presented the Warthog Network crypto project which stands out of the masses in terms of decentralization, technology and innovation. Unique flagship features include the specifically designed Janushash algorithm based on newly invented Proof of Balanced Work technology, which honors Satoshi's ideals of mining democratization, the browser full nodes with WasmFS persistence and P2P WebRTC communication, and the DeFi2 implementation which solves current DeFi's biggest problem #box[_MEV extraction_] through Fair Batch Matching and adds new features such as dividends, scriptless proportional airdrops to token holders, and balance cloning in a clean and user-friendly way. With the fair initial coin distribution based purely on mining and its thriving community Warthog's future shines bright.

#show: appendix

= Block Structure


The binary content of a block is a concatenation of the following sections in their specified order:

+ Mining section
+ New address section
+ Reward section
+ Transfer section
+ Token transfer section
+ Asset creation section
+ Limit swap section
+ Liquidity deposit section
+ Liquidity withdrawal section
+ Cancelation section
+ Match section

Below we describe the above sections. All numbers and id values are in network byte order.

== Mining section

This section allows miners to put 4 bytes of arbitrary data to affect the merkle hash.

#let bytetable(caption,..entries) = {
figure(
  caption: caption,
  table(columns: 2, align: left, table.header([*byte range*], [*content*]), ..entries)
)
}

#bytetable([Mining Section],
    [1-4], [arbitrary data])

== New address section

This section lists new addresses that receive payments in this block and therefore need to be added to the `state` table. This way they will be assigned a new id value which is referenced in the other sections to specify a particular account.

#bytetable([New Address Section],
    [1-4], [number  `n` of new addresses],
    [5-(4+n*20)], [`n` addressess of 20 bytes each])


Miners are responsible to ensure that the addresses appearing in the new address section are not already present in the state table and are actually referenced in this block. Otherwise the block is considered invalid.

== Reward section

Mining reward is distributed to at least one reward address. (Need to be reworked as last commit change this)

#bytetable([Reward Section],
    [1-2], [number  `r` of reward entry],
    [3-(4+n*16)], [`r` reward entries]
)

Every reward entry consists of 16 bytes:

#bytetable([Reward entry],
    [1-8], [accountId],
    [9-16], [amount]
)

The sum of the amounts received by the addresses listed in the mining reward section must not exceed the total mining reward (block reward + transaction fees), otherwise the block is considered invalid.

The total size of the mining section is `2 + r * 16` bytes.

== Transfer section

The transfer section contains the transfers made in this block. Its binary outline is as follows:

#bytetable([Transfer Section],
[1-4], [number `t` of transfer entries],
[5-(4+t*99)], [`t` transfer entries]
)

Every transfer entry has the following structure:

#bytetable( [Transfer structure],
    [1-8], [fromAccountId],
    [9-16], [pinNonce], 
    [17-18], [fee], 
    [19-26], [toAccountId], 
    [27-34], [amount], 
    [35-99], [recoverable signature (65 bytes)]
)

Each payment entry has length 99 bytes. Compare this to the average transaction size of around 200 bytes per Bitcoin transfer.
== Asset Creation Section

The asset creation section contains transactions that create new tokens on the Warthog network. Asset names can have at most 5 alphanumeric (`[a-zA-Z0-9]`) characters and must be unique across the network. When an asset is created, the entire initial supply is credited to the creator's account.

#bytetable([Asset Creation Section],
    [1-4], [number `a` of asset creation entries],
    [5-(4+a*73)], [`a` asset creation entries]
)

Every asset creation entry has the following structure:

#bytetable([Asset creation entry],
    [1-8], [creatorAccountId],
    [9-16], [pinNonce],
    [17-18], [fee],
    [19-23], [asset name (5 bytes, null-padded)],
    [24-31], [total supply (uint64)],
    [32-32], [decimals (1 byte)],
    [33-97], [recoverable signature (65 bytes)]
)

The decimals field specifies how many decimal places the asset supports, affecting how token amounts are interpreted in fixed-point arithmetic.

== Token Transfer Section

The token transfer section handles transfers of non-WART tokens, including both regular assets and liquidity tokens. This distinguishes between regular asset transfers and pool liquidity token transfers.

#bytetable([Token Transfer Section],
    [1-4], [number `t` of token transfer entries],
    [5-(4+t*106)], [`t` token transfer entries]
)

Every token transfer entry has the following structure:

#bytetable([Token transfer entry],
    [1-8], [fromAccountId],
    [9-16], [pinNonce],
    [17-18], [fee],
    [19-26], [toAccountId],
    [27-30], [assetId],
    [31-46], [amount (16 bytes, asset-specific precision)],
    [47-111], [recoverable signature (65 bytes)]
)

The `isLiquidity` flag, which indicates whether the transferred token is an asset or a liquidity token, is determined by the asset ID referencing either a standard asset or a liquidity pool's share token.

== Limit Swap Section

The limit swap section contains buy and sell orders for the decentralized exchange. Each order specifies a base asset, a limit price expressed in WART, and a quantity.

#bytetable([Limit Swap Section],
    [1-4], [number `l` of limit swap entries],
    [5-(4+l*90)], [`l` limit swap entries]
)

Every limit swap entry has the following structure:

#bytetable([Limit swap entry],
    [1-8], [accountId],
    [9-16], [pinNonce],
    [17-18], [fee],
    [19-22], [assetId],
    [23-30], [amount],
    [31-46], [limit price (16 bytes, encoded price)],
    [47-47], [buy/sell flag (1 byte)],
    [48-112], [recoverable signature (65 bytes)]
)

The buy/sell flag determines the direction of the order: a value of `1` indicates a buy order (trader wants to purchase the asset with WART), while `0` indicates a sell order (trader wants to sell the asset for WART).

== Liquidity Deposit Section

The liquidity deposit section records deposits of base asset and WART into liquidity pools, which mint liquidity tokens in return.

#bytetable([Liquidity Deposit Section],
    [1-4], [number `d` of liquidity deposit entries],
    [5-(4+d*97)], [`d` liquidity deposit entries]
)

Every liquidity deposit entry has the following structure:

#bytetable([Liquidity deposit entry],
    [1-8], [accountId],
    [9-16], [pinNonce],
    [17-18], [fee],
    [19-22], [assetId],
    [23-38], [base amount],
    [39-54], [quote amount (WART)],
    [55-119], [recoverable signature (65 bytes)]
)

The liquidity pool automatically calculates the number of liquidity tokens to mint based on the deposited amounts and current pool reserves.

== Liquidity Withdrawal Section

The liquidity withdrawal section records redemptions of liquidity pool shares for underlying base asset and WART.

#bytetable([Liquidity Withdrawal Section],
    [1-4], [number `w` of liquidity withdrawal entries],
    [5-(4+w*89)], [`w` liquidity withdrawal entries]
)

Every liquidity withdrawal entry has the following structure:

#bytetable([Liquidity withdrawal entry],
    [1-8], [accountId],
    [9-16], [pinNonce],
    [17-18], [fee],
    [19-22], [assetId],
    [23-38], [shares redeemed],
    [39-103], [recoverable signature (65 bytes)]
)

== Cancelation Section

The cancelation section contains references to transactions that should be invalidated. This includes pending transactions in the mempool and open orders in the order book.

#bytetable([Cancelation Section],
    [1-4], [number `c` of cancelation entries],
    [5-(4+c*49)], [`c` cancelation entries]
)

Every cancelation entry has the following structure:

#bytetable([Cancelation entry],
    [1-8], [accountId],
    [9-16], [pinNonce],
    [17-20], [pinHeight],
    [21-38], [recoverable signature (18 bytes)]
)

Once a transaction is canceled, it cannot be included in any future block, effectively blocking it from execution.

== Match Section

The match section is an implicit transaction generated by the node during block processing. It records the result of the Fair Batch Matching algorithm applied to all swap orders and liquidity pool interactions within the block.

#bytetable([Match Section],
    [1-4], [number `m` of match entries],
    [5-(4+m*81)], [`m` match entries]
)

Every match entry has the following structure:

#bytetable([Match entry],
    [1-4], [assetId],
    [5-20], [pool base before (16 bytes)],
    [21-36], [pool quote before (16 bytes)],
    [37-52], [pool base after (16 bytes)],
    [53-68], [pool quote after (16 bytes)],
    [69-76], [buy swaps count + offset],
    [77-81], [sell swaps count + offset]
)

The match entry records the state of the liquidity pool before and after the FBM matching, along with references to the individual swaps. The buySwaps and sellSwaps arrays, which can be empty for blocks with no matching activity, contain the history IDs of the matched orders and the amounts swapped in each direction.
#pagebreak()
#par(justify:false, [
= Link Collection
- Website: https://www.warthog.network/
- Github: https://github.com/warthog-network
- Gui Wallet: https://github.com/andrewcrypto777/wart-wallet
- PoBW whitepaper: https://github.com/CoinFuMasterShifu/ProofOfBalancedWork/blob/main/PoBW.pdf
- Fair Batch Matching paper: https://github.com/CoinFuMasterShifu/FairBatchMatching/blob/main/FairBatchMatching.pdf
- Janushash: https://warthog.network/docs/janushash
- Guide for pool devs: https://warthog.network/docs/developers/integrations/pools/
- Guide for miner devs: https://warthog.network/docs/developers/integrations/miners/
- Guide: https://github.com/warthog-network/warthog-guide
- Explorer: https://wartscan.io/
- Client Explorer: https://github.com/warthog-network/client-explorer
- Discord: https://discord.com/invite/QMDV8bGTdQ
- Telegram: https://t.me/warthognetwork
- Bitcointalk: https://bitcointalk.org/index.php?topic=5458046.0
- API documentation: https://github.com/warthog-network/Warthog/blob/master/doc/API.md
- Reddit: https://www.reddit.com/r/warthognetwork/
- Pool: https://warthog.acc-pool.pw/
- Wart-Dapp: https://github.com/warthog-network/wart-dapp/releases
- Coingecko: https://www.coingecko.com/en/coins/warthog
- Exbitron: https://exbitron.com/trade?market=wart-usdt
- Tradeogre: https://tradeogre.com/exchange/WART-USDT
- Xeggex: https://xeggex.com/market/WART_USDT
- Miningpoolstats: https://miningpoolstats.stream/warthog
- Coinpaprika: https://coinpaprika.com/coin/wart-warthog/
- Livecoinwatch: https://www.livecoinwatch.com/price/WarthogNetwork-WART
- DeFi Demo: https://warthog.network/defi-demo
])

#pagebreak()
#bibliography("cite.bib")
