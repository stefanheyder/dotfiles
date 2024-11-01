#!/usr/bin/Rscript

# Import Bibtex file into Obsidian
library(bibtex)
library(stringr)

if (file.exists("~/Exported Items.bib")) {
    exported <- read.bib("~/Exported Items.bib")

    for (key in names(exported)) {
        fname <- paste0("/home/stefan/Nextcloud/obsidian/workspace/_Inbox/", key, ".md")

        if (file.exists(fname)) {
            print(str_interp("File ${fname} already exists!"))
        } 
        else {
            title <- str_replace_all(exported[key]$title, '[{}]', '')
            author <- str_c(exported[key]$author, sep = ';', collapse = '; ')
            first_author <- word(as.character(exported[key]$author[1]), -1)
            year <- exported[key]$year

            str_interp("---
title: \"${title}\"
author: ${author}
year: ${year}
alias: [\"${title}\", ${first_author}${year}]
---

%% 

FROZEN - Obsidian:
PaperInfo: ${first_author}${year} - ${title}

%%

# Summary of ${first_author} ${year}

# Key ideas of ${first_author} ${year}


") %>% write(file = fname)

            print(str_interp("Created file ${key}.md"))
        }
    }

    file.remove("~/Exported Items.bib")
}
