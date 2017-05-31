# About

This uses a naive Bayesian algorithm to suggest a tag/category based on a link specified. You can train the data by putting more information into the `training_links.txt` in the format of `tag1 tag2 tag3 link`

The eventual goal of this is to plug it into my `Bookmarker` Rails app to help people find tags/communities based on a link they want to share.

# Example

With the training data
```
programming blog https://codinghorror.com
code machine-learning https://stackoverflow.com/questions/7523916/return-string-until-matched-string-in-ruby
blog https://coding.com
code https://stackoverflow.com/
code machine-learning https://stackoverflow.com/
```

A query with a link of `https://codinghorror.com` will give us the following probabilities:
`{"programming"=>(1/5), "blog"=>(2/5), "code"=>(1/5), "machine-learning"=>(1/5)}`.

Thus, `https://www.codinghorror.com is blog with 2/5 accuracy`

# Todo

Right now, this is only guessing based on specific links. There is no language processing based on the link's title or anything. It's quite limited thus is a proof of concept at the moment.
