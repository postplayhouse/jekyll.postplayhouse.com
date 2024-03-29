---
title: Ratings
permalink: /ratings/
layout: page
regenerate: true
---

Starting in 2017, all of our productions have been labelled with an unofficial rating. We say "unofficial" because we are not adhering to any sort of national standard for theatre ratings, since no such thing exists.

We do, however, want to provide a little bit of guidance to our patrons. For now, we are using two ratings: G and H. The first rating, G, *resembles* the movie rating of the same name and is meant to imply as much. G is what we consider suitable for audiences of any age. H is meant to imply that the show may not be suitable for all audiences and an explanation is given next to the rating. We have no higher rating than H, so it encompasses all content beyond G. We may assign a rating of H to a show for any number of reasons, including that it might be a little scary, confusing, or boring for young children.

Over the years, we have entertained thousands of people from all over Nebraska, the United States, and abroad. The number of complaints we have received for content of our productions amounts to something on the order of one one-hundredth of one percent of all audience members. All this to say that we choose shows that we believe all our patrons will be in some way delighted to experience, and we haven't missed the mark yet.

If you are ever curious about the content of a production, you can call our box office after approximately late-May every year and talk to our summer box office staff. They are always happy to help guide you in choosing which productions to see for the summer.

## Ratings for {{site.season}}

{%- assign productions = site.data.productions[site.season] | sort: "opening" -%}
{%- for production in productions -%}
  * {{ production.title }} - {{ production.rating }}

    {{ production.rating_explanation }}

{%- endfor -%}
