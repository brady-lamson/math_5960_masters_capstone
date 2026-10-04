# Notes

Today was mostly a lot of thinking. I went in the direction of turning the response into a proportion. So people in agriculture / people in all industries. I think this approach makes sense as the bureau has guidelines on doing this transformation and other methods would be awkward to adjust for the model. Using the denominator as the a covariate is awkward as the MOE isn't accounted for there. 

For the conversion, it's in the same 2021 instructions guide from the ACS as the conversion from MOE to SD. It gives the following formula.

$$
\text{Let } P=A/B \\
SE(P) = \frac{1}{B} \cdot \sqrt{SE(A)^2 - (P^2 \cdot SE(B)^2)}
$$

Overall I got it fit and got initial results. The shrinkage values don't go as extreme which is nice. There are no real problematic adjustments in terms of absurdly large deltas. It all appears more well behaved. The model still totally sucks as it's an intercept only model but I feel this setup may cooperate more. Will need to get some guidance on this. 

I don't have a ton to write about today. I really gotta get my head wrangled around what exactly I'm doing that's new and useful. There's plenty of other literature on this model, is my setup actually novel or is this a waste of everyones time? It's hard to say at this point, but I'm going to keep pushing forward. I need to get more models fit by the next meeting with the professor on Friday September 11th. So that means figuring out autocorrelation or the spatial co variate. Both will require some review. 