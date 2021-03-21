---
title: "How to build a github page with hugo"
date: 2021-03-20T20:53:15+11:00
---

This article will talk about how to use hugo, Github Pages and Github Actions to build a blog.

### Hugo Installation
First of all, you will need to install hugo locally. I am using Linux, so the command is
```
# Ubuntu
snap install hugo
```
Other installation detail can be found [here](https://gohugo.io/getting-started/installing/)

### Build Site Locally
The next is to build the project and add theme `ananke` by
```
hugo new site quickstart
cd quickstart
git submodule add https://github.com/budparr/gohugo-theme-ananke.git themes/ananke
```

The list of theme can be found [here](https://themes.gohugo.io/)

and now you can see the result at `http://localhost:1313/` after running
```
hugo server
```

and now you can add a new post by running the following command
```
hugo new posts/my-first-post.md
```

but you would think why it doesn't show up in my web page? because it is in
draft mode, you will need to update `draft` optino to be `false`, and you can
see the page now.

### Create Github Page

Before we start to proceed to Github Page, the first thing you need to do is
to change the `baseURL` in your `config.toml` to be `https://<USER_NAME>.github.io`.

After you successfully create the site locally with Hugo. The next step is to
create a Github Page. The first thing is to create the repo, there are two
things to note
* This repo should be public repo unless you are a paid user.
* This repo has to be named as `<USER_NAME>.github.io`.

After create the repo and push your change to the repo, 
there are two ways to make Github Page work with Hugo

The first way is to add `publishDir = "docs"` to your `config.toml` file to 
tell Hugo to generate the frontend manifest to `/docs` folder and update your
repo setting to use `/docs` as the Github Page source. One thing to note is that
you will need to remove `/docs` entirely and regenerate it every time you make
changes which is a little bit cumbersome.

The second way is to use Github Action [actions-hugo](https://github.com/peaceiris/actions-hugo).
The following is the example config which should be at `.github/workflow/gh-pages.yml` and you
will need to config your repo to use `gh-pages` as target branch. What this Github Action is doing
is to generate the frontend manifest for you and push it to `gh-pages` branch, so you don't need to
delete and generate the files to `/docs` every time which is really nice.
```
name: github pages

on:
  push:
    branches:
      - main  # Set a branch to deploy

jobs:
  deploy:
    runs-on: ubuntu-18.04
    steps:
      - uses: actions/checkout@v2
        with:
          submodules: true  # Fetch Hugo themes (true OR recursive)
          fetch-depth: 0    # Fetch all history for .GitInfo and .Lastmod

      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v2
        with:
          hugo-version: '0.81.0'
          # extended: true

      - name: Build
        run: hugo --minify

      - name: Deploy
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./public
```

### Check Your Site

Now you will be able to see your website in `https://<USER_NAME>.github.io`!

