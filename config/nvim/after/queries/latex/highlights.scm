;; extends

((generic_command
  command: (command_name) @_name
  arg: (curly_group (_) @markup.emphasis))
  (#eq? @_name "\\emph"))

((generic_command
  command: (command_name) @_name
  arg: (curly_group (_) @nospell))
  (#any-contains? @_name "\\email" "ref"))

(class_include) @nospell
(new_command_definition) @nospell

(line_comment) @nospell
(block_comment) @nospell
(comment_environment) @nospell

(math_environment
  (text) @nospell)
(math_delimiter) @nospell

(graphics_include) @nospell
(path) @nospell

(author_declaration
  command: _ @namespace
  authors: (curly_group_author_list
             ((author)+ @nospell)))

(label_definition) @nospell
(label_reference) @nospell

(citation) @nospell

(bibstyle_include) @nospell

(ERROR) @nospell
