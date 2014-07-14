---
title: Project Conventions
path: overview/projects
---

# Introduction

SDK projects follow a number of conventions for file management to simplify orientation for 
developers starting work on an existing codebase. Some conventions are expected by tools like 
MassiveTask and MassiveUnit. These defaults should only be changed when absolutely required.

# Directory Structure

- the top level of a project should contain mostly directories, not files
- follow existing conventions, keep things tidy

Example:

```
/bin - compiled output
/src - source code
/test - unit/functional tests
/doc - documentation
```

> TODO: More information on structure expected by `mtask`, `munit` etc.

# Files

A project should contain everything required to be compile by another developer, with the exception 
of external dependencies and the Haxe toolchain.

IDE and editor specific files should *not* be commited to a project repository.

Project names should be descriptive, but concise. They need only be unique within the context of 
the organisation creating the application. As they are, by convention, used for naming application 
targets, they should contain only alpha-numeric characters and no spaces. Project names should 
also be capitalised.

Good: MassiveUI, MassiveCover
Bad: my_First Project-1027, ClientName_ProjectName_Version_1087_Final_final_this_one

Names in general should be lowercase (except sub projects, like modules), singular (asset, not 
assets) and without spaces. Dashes are preferred as separators to underscores.

Good: working/design, asset/icon/close.png, resource/samsung-js
Bad: working/Design Assets, asset/icons/CloseIcon.png, resource/samung_js

# Version Control

> TODO
