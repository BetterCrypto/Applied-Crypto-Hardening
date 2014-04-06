# File        : mfirstuc.perl
# Author      : Nicola L. C. Talbot
# Date        : 2012-09-21
# Version     : 1.0
# Description : LaTeX2HTML (limited!) implementation of mfirstuc package

# This is a LaTeX2HTML style implementing the mfirstuc package, and
# is distributed as part of the glossaries package.
# Copyright 2007 Nicola L.C. Talbot
# This work may be distributed and/or modified under the
# conditions of the LaTeX Project Public License, either version 1.3
# of this license of (at your option) any later version.
# The latest version of this license is in
#   http://www.latex-project.org/lppl.txt
# and version 1.3 or later is part of all distributions of LaTeX
# version 2005/12/01 or later.
#
# This work has the LPPL maintenance status `maintained'.
#
# The Current Maintainer of this work is Nicola Talbot.

use warnings;

package main;

sub do_cmd_makefirstuc{
   local($_) = @_;

   local($id,$text);

   $text = &missing_braces unless
      s/$next_pair_pr_rx/$id=$1;$text=$2;''/eo;

   &translate_commands("\\glsmakefirstuc $text") . $_;
}

sub do_cmd_xmakefirstuc{
   local($_) = @_;

   local($id,$text);

   $text = &missing_braces unless
      s/$next_pair_pr_rx/$id=$1;$text=$2;''/eo;

   unless ($id)
   {
      $id = ++$global{'max_id'};
   }

   &translate_commands("\\expandafter \\makefirstuc $OP$id$CP$text$OP$id$CP")
   . $_;
}

sub do_cmd_glsmakefirstuc{
   local($_) = @_;

   local($id,$text);

   $text = &get_next_object unless
      s/$next_pair_pr_rx/$id=$1;$text=$2;''/eo;

   &do_real_makefirstuc($text).$_;
}

sub do_real_makefirstuc{
   local($text) = @_;

   if ($text=~/^((?:\s*<[^>]+>\s*)+)(.*)/)
   {
      $text = $1 . ucfirst($2);
   }
   else
   {
      $text = ucfirst($text);
   }

   $text;
}

sub do_cmd_capitalisewords{
   local($_) = @_;

   local($id,$text);

   $text = &missing_braces unless
      s/$next_pair_pr_rx/$id=$1;$text=$2;''/eo;

   local($newtext) = '';

   foreach my $word (split ' ', $text)
   {
      $id = ++$global{'max_id'};

      $word = &translate_commands("\\makefirstuc $OP$id$CP$word$OP$id$CP");

      if ($newtext)
      {
         $newtext .= ' ' . $word;
      }
      else
      {
         $newtext = $word;
      }
   }

   $newtext.$_;
}

sub get_next_object{
    local($next, $revert, $thisline);
    local($this_cmd) = $cmd;
    $this_cmd =~ s/^\\// unless ($cmd eq "\\");
    if (/^[\s%]*([^\n]*)\n/ ) {
        $thisline = &revert_to_raw_tex($1)
    } else {
        $thisline = &revert_to_raw_tex($_);
    }
    s/^\s*//;
    if ($_ =~ s/$next_token_rx//) { $next = $& };
    $next =~ s/$comment_mark(\d+\n?)?//g;
    if ($next =~ /^\\(\W|\d|[a-zA-z]*\b)/) {
        $revert = $next = "\\".$1;
    } elsif ($next =~ /\W/) {
        $revert = &revert_to_raw_tex($next);
    } else { $revert = $next };
    $next;
}

1;
