One very cool thing about the evolving distributed autonomous organization (DAC/DAO) layer on top of cryptocurrencies is that it increasingly allows programmable governance.

This paper includes my best thoughts on an optimal approach. It is partially an attempt to resolve the tension that for most projects there is an early need for centralization (i.e. classic startup) vs. the legitimate desire to have more voices heard as things evolve. Many projects also need funding in order to get started and need to accomodate investor interests. 

Here are some existing models:

 * Current corporate model is investors decide via board seat allocation. You only have an opening once you hit IPO, but there are severe barriers to IPO which seem to be increasing. 

 * Cooperative model and non-profits I perceive as extremely inefficient in the early stages. Among other things they need a board, have high initial costs, and don't scale internationally.

 * Some cryptocurrencies have a "founder lock" on fund received via multi-sig, which is cool but doesn't exactly address the issue of evolved control over time and generally assumes static decision makers. Actual decision making is a bit vague at this point and not captured in the protocol layer. 

My optimal model is something like: 

     *  All major "board level" decisions captured in blockchain format. 
     * "Board level" decisions decide allocation of funds, which then go into pools
     *  Pools of funds allocated to individuals/projects can each have one or many decision makers. Once allocated pools have complete autonomy. 
     *  "Boards" have the following decision-makers, "founders," "investors," "users."
     *  Voting is handled by a two-tiered process in which each group allowed one or more proxies. Those proxies become a board. This board then makes relevant decisions. 
    
To illustrate, here's a sample timeline:  
    
  *time 0.* board members 1. founder 1. 

  *time + 30 days.* fundraiser, reception of $5M. all investors vote, elect a board member.  board members 2. founder 1. lead investor 1.  

  *time + 31 days.* 2 board members unanimously vote to create $1.5M pool for founder. 

  *time + 32 days.* Founder hires 5 full time staff to build cool shit. Approves various related expenses.

  *time + 180 days.* Project has 2 million verified accounts. board is expanded to 3 members. Users vote and elect a representative. Voting is as follows. Anyone can nominate themselves up until 7 days prior to election. The person with the most votes wins. Serves 12 month term. 

  *time + 181 days.* Board debates and unanimously decides to disperse an additional $2.5M. 

  *time + 182 days.* 15 more people hired. Various other expenses approved. 

  *time + 365 days.* 50 million verified accounts. Board increases to 4, 1 founder, 1 investor, 2 user. New election for new user board. 

  *time + 366 days.* Board votes 3/4 to open a new fund-raising round, seeking an additional $20M. 

  *time + 400 days.* $20M received, new investor election, new board position. Board increase to 5. 1 founder, 2 investor, 2 user.   

Open questions:

     *  Can the number of board members automatically scale to the appropriate number? Is this linear with respect to time or with respect to some other quantity (i.e. amount of funds and/or users)
     *  What's the length of time for positions? Can this also be programmable? 
     *  How can you verify users (i.e. not allow fake accounts)?
     *  Can the voting also be handled on the blockchain?
     *  Is board one person one vote or can/should votes be weighted?
     *  How does this ideally evolve after the initial stages?  Linear increase in board members?  
     *  Is this just a nice idea or can this be programmed into a metacoin or Ethereum? 


Suggestions, starting with open questions: 
1. This would ideally be adjustable with each DAC, as different models could be more ideal for different situation. Individual share holders should always be allowed to enlarge the board by vote. 
2. Programmable 
3. Much harder to do, which is why decesion making should be focused with share (coin) holders. As this is verified by the blockchain you can't "double spend" votes. 
4. Major board level decesions and fund allocations could be shown on the blockchain through a variety of means. One obvious solution is generating a new coin for every vote, and have them sent to different "burn" addresses to represent each option. 
5. Adjustable per DAC, but for reasons mentioned prior votes should be weighted by ownership of shares. 
6. There will also be a balance between representation and decesion making effeciency, which shall vary with each DAC. Should be fully programmable and votable. 
7. Metacoins have limitations, and Ethereum is too new to forsee how it will ultimatly play out. There's also downsides to using a new medium of exchange to run the ecosystem, making sidechains a very attractive option should they come into play. However Ethereum will be at the very least a place to do many proof of concepts and experiments in all of this. 
8. 


My optimal model would allow a founder to maintain effective control of finances as long as they don't sell <50% of shares for fundraising. Votes and proxies can still be adopted for feedback and differing opinions. In the event that the founder doesnt control <50% then a true "corporate" structure developes, although much more transparent and flexible than legacy corporations. A majority (or its proxies) can vote for an executive board including a CEO, and legitamize the decesion by allocating them funds from the main multisig wallet for operations. Users, as they are impossible to accuratly represent due to fraud, bots, etc. do not get a *decesion making* role, but whose feedback can always be solicited in various ways. In addition users who would like to take an active role in decesion making simply need buy shares into the DAC, already a pretty simple proccess. 

With all this in mind the main tools we are looking for are:

     *  A Multi-sig wallet tied to the DAC shares, recquiring votes<50% for any transactions (pools of funds for operations and other expenses can easily be allocated and audited as a result)
     *  Basic built in tools to initiate votes, most easily done with "burnable" tokens
     *  Tool by which investors can vote proxies who inherit the decesion making weight of their voters in regards to blockchain recorded decesions, for the extent of their term. 


That would be a sufficient framework for most any "distributed company" to be formed, and for more advanced "Autonomous" orginizations (DAOs) to be built on later. 
  
    
