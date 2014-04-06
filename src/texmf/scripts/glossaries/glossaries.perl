# File          : glossaries.perl
# Author        : Nicola L.C. Talbot
# Date          : 14th June 2007
# Last Modified : 2012-09-21
# Version       : 1.05
# Description   : LaTeX2HTML (limited!) implementation of glossaries
#                  package. Note that not all the glossaries.sty
#                  macros have been implemented.

# This is a LaTeX2HTML style implementing the glossaries package, and
# is distributed as part of that package.
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

# This work consists of the files glossaries.dtx and glossaries.ins
# and the derived files glossaries.sty, glossary-hypernav.sty,
# glossary-list.sty, glossary-long.sty, glossary-super.sty,
# glossaries.perl, mfrstuc.perl. Also makeglossaries and makeglossaries.bat

package main;

&do_require_package("mfirstuc");

 %glossary_style = ();
 &set_glossarystyle('altlist');# default style

 $CURRENT_STYLE='altlist';

&process_commands_nowrap_in_tex( <<_RAW_ARG_CMDS_);
newglossarystyle # {} # {}
_RAW_ARG_CMDS_

# These are the only package options implemented.

sub do_glossaries_style_altlist{
}

sub do_glossaries_toc{
}

sub do_glossaries_toc_true{
}

$INDEXONLYFIRST=0;

sub do_glossaries_indexonlyfirst{
  $INDEXONLYFIRST=1;
}

$gls_nonumberlist{'main'} = 0;

sub do_glossaries_nonumberlist{
  $gls_nonumberlist{'main'} = 1;
}

$GLSCURRENTFORMAT="textrm" if (!defined($GLSCURRENTFORMAT));
$GLOSSARY_END_DESCRIPTION = '.' if (!defined($GLOSSARY_END_DESCRIPTION));

sub do_cmd_glossaryname{
   "Glossary$_[0]"
}

$gls_mark{'main'} = "<tex2html_gls_main_mark>";
$gls_file_mark{'main'} = "<tex2html_gls_main_file_mark>";
$gls_title{'main'} = "\\glossaryname";
$gls_toctitle{'main'} = "\\glossaryname";
$delimN{'main'} = ", ";
$glsnumformat{'main'} = $GLSCURRENTFORMAT;
@{$gls_entries{'main'}} = ();
$gls_displayfirst{'main'} = "glsdisplayfirst";
$gls_display{'main'} = "glsdisplay";

 %glsentry = ();

$acronymtype = 'main';

sub do_glossaries_acronym{
   &do_glossaries_acronym_true
}

sub do_glossaries_acronym_true{
   &make_newglossarytype("acronym", "\\acronymname");
   $acronymtype = 'acronym';
}

sub do_glossaries_acronym_false{
   $acronymtype = 'main';
}

sub do_cmd_acronymname{
   join('', 'Acronyms', $_[0]);
}

sub do_cmd_acronymtype{
   join('', $acronymtype, $_[0]);
}

$global{'glossaryentry'} = 0;
$global{'glossarysubentry'} = 0;

sub do_cmd_theglossaryentry{
  join('', $global{'glossaryentry'}, $_[0]);
}

sub do_cmd_theglossarysubentry{
  join('', $global{'glossarysubentry'}, $_[0]);
}

sub do_glossaries_entrycounter{
  &do_glossaries_entrycounter_true
}

sub do_glossaries_entrycounter_true{
  eval(<<'_END_DEF');
  sub do_cmd_glsresetentrycounter{
    $global{'entrycounter'} = 0;
    $_[0];
  }
_END_DEF
}

sub do_glossaries_entrycounter_false{
  eval(<<'_END_DEF');
  sub do_cmd_glsresetentrycounter{
    $_[0];
  }
_END_DEF
}

sub do_cmd_glsresetentrycounter{$_[0];}

sub do_glossaries_subentrycounter{
  &do_glossaries_subentrycounter_true
}

sub do_glossaries_subentrycounter_true{
  eval(<<'_END_DEF');
  sub do_cmd_glsresetsubentrycounter{
    $global{'subentrycounter'} = 0;
    $_[0];
  }
_END_DEF
}

sub do_glossaries_subentrycounter_false{
  eval(<<'_END_DEF');
  sub do_cmd_glsresetsubentrycounter{
    $_[0];
  }
_END_DEF
}

sub do_cmd_glsresetsubentrycounter{ $_[0]; }

# modify set_depth_levels so that glossary is added

sub replace_glossary_markers{
   foreach $type (keys %gls_mark)
   {
      if (defined &add_gls_hook)
        {&add_gls_hook if (/$gls_mark{$type}/);}
      else
        {&add_gls($type) if (/$gls_mark{$type}/);}

      s/$gls_file_mark{$type}/$glsfile{$type}/g;
   }
}

# there must be a better way of doing this
# other than copying the original code and adding to it.
sub replace_general_markers {
    if (defined &replace_infopage_hook) {&replace_infopage_hook if (/$info_page_mark/);}
    else { &replace_infopage if (/$info_page_mark/); }
    if (defined &add_idx_hook) {&add_idx_hook if (/$idx_mark/);}
    else {&add_idx if (/$idx_mark/);}
    &replace_glossary_markers;

    if ($segment_figure_captions) {
s/$lof_mark/$segment_figure_captions/o
    } else { s/$lof_mark/$figure_captions/o }
    if ($segment_table_captions) {
s/$lot_mark/$segment_table_captions/o
    } else { s/$lot_mark/$table_captions/o }
    &replace_morelinks();
    if (defined &replace_citations_hook) {&replace_citations_hook if /$bbl_mark/;}
    else {&replace_bbl_marks if /$bbl_mark/;}
    if (defined &add_toc_hook) {&add_toc_hook if (/$toc_mark/);}
    else {&add_toc if (/$toc_mark/);}
    if (defined &add_childs_hook) {&add_childs_hook if (/$childlinks_on_mark/);}
    else {&add_childlinks if (/$childlinks_on_mark/);}
    &remove_child_marks;

    if (defined &replace_cross_references_hook) {&replace_cross_references_hook;}
    else {&replace_cross_ref_marks if /$cross_ref_mark||$cross_ref_visible_mark/;}
    if (defined &replace_external_references_hook) {&replace_external_references_hook;}
    else {&replace_external_ref_marks if /$external_ref_mark/;}
    if (defined &replace_cite_references_hook) {&replace_cite_references_hook;}
    else { &replace_cite_marks if /$cite_mark/; }
    if (defined &replace_user_references) {
  &replace_user_references if /$user_ref_mark/; }

}

sub add_gls{
    local($sidx_style, $eidx_style) =('<STRONG>','</STRONG>');
    if ($INDEX_STYLES) {
if ($INDEX_STYLES =~/,/) {
local(@styles) = split(/\s*,\s*/,$INDEX_STYLES);
    $sidx_style = join('','<', join('><',@styles) ,'>');
    $eidx_style = join('','</', join('></',reverse(@styles)) ,'>');
} else {
    $sidx_style = join('','<', $INDEX_STYLES,'>');
    $eidx_style = join('','</', $INDEX_STYLES,'>');
}
    }
    &add_real_gls
}

sub gls_compare{
   local($x, $y) = @_;

   if ($x eq '' or $y eq '')
   {
      if ($x ne '')
      {
         # y is the shorter string
         return 1;
      }
      elsif ($y ne '')
      {
         # x is the shorter string
         return -1;
      }
      else
      {
         # both empty
         return 0;
      }
   }

   local($x0) = '';
   local($y0) = '';

   if ($x=~s/^(&#(?:\d+|x[\da-f]+);)//)
   {
      $x0 = $1;
   }
   elsif ($x=~s/^(.)//)
   {
      $x0 = $1;
   }

   if ($y=~s/^(&#(?:\d+|x[\da-f]+);)//)
   {
      $y0 = $1;
   }
   elsif ($y=~s/^(.)//)
   {
      $y0 = $1;
   }

   local($numx);

   if ($x0=~/&#(\d+|x[\da-f]+);/)
   {
      $numx = $1;

      $numx = hex("0$numx") if $numx=~/^x/;
   }
   else
   {
      $numx = ord($x0);
   }

   local($numy);

   if ($y0=~/&#(\d+|x[\da-f]+);/)
   {
      $numy = $1;

      $numy = hex("0$numy") if $numy=~/^x/;
   }
   else
   {
      $numy = ord($y0);
   }

   if ($numx == $numy)
   {
      return &gls_compare($x, $y);
   }
   elsif ($numx >= 48 and $numx <= 57) # x in range '0' ... '9'
   {
      if ($numy >= 48 and $numy <= 57) # y in range '0' ... '9'
      {
         return $numx <=> $numy;
      }
      elsif (($numy >= 97 and $numy <= 122) or ($numy >= 65 and $numy <= 90)) # y a letter
      {
         # digits are less than letters
         return -1;
      }
      else
      {
         # digits are greater than symbols
         return 1;
      }
   }
   elsif (($numx >= 97 and $numx <= 122) or ($numx >= 65 and $numx <= 90)) # x a letter
   {
      if (($numy >= 97 and $numy <= 122) or ($numy >= 65 and $numy <= 90)) # y a letter
      {
         if (($numx <= 90 and $numy <= 90) or ($numx >= 97 and $numy >= 97))
         {
            # same case (already checked if they are equal)

            return $numx <=> $numy;
         }

         # are they upper/lower case versions of each other?

         if (($numx >= 97 and $numy == $numx-32))
         {
            # x is upper case version of y

            if ($x or $y)
            {
               return &gls_compare($x, $y);
            }
            else
            {
               return -1;
            }
         }

         if (($numy >= 97 and $numx == $numy-32))
         {
            # y is upper case version of x

            if ($x or $y)
            {
               return &gls_compare($x, $y);
            }
            else
            {
               return 1;
            }
         }

         # compare lower case values
         return lc(chr($numx)) cmp lc(chr($numy));
      }
      else
      {
         # a-z greater than symbols and digits
         return 1;
      }
   }
   elsif ($numy >= 48 and $numy <= 57) # y in range '0' ... '9'
   {
      # already checked for '0' < x < '9' and '0' < y < '9'
      # already checked for 'a' < x < 'z' and '0' < y < '9'

      # digits greater than symbols
      return 1;
   }
   elsif (($numy >= 97 and $numy <= 122)  or ($numy >= 65 and $numy <= 90)) # y is a letter
   {
      # already checked for x is digit and y a is letter
      # already checked for x is letter and y a is letter

      # symbols and digits are less than letters

      return -1;
   }

   $numx <=> $numy
}

sub gloskeysort{

   $a=~/^(.*)###(\d+)$/;

   local($labelx) = $1;
   local($x_id) =$2;

   $b=~/^(.*)###(\d+)$/;

   local($labely) = $1;
   local($y_id) = $2;

   local($sortx) = &gls_get_sort($labelx);
   local($sorty) = &gls_get_sort($labely);

   local($n);

   # are they case-insensitive equivalent?

   if (lc($sortx) eq lc($sorty))
   {
      $n = ($sortx cmp $sorty);
   }
   else
   {
      $n = &gls_compare($sortx, $sorty);
   }

   unless ($n)
   {
      $n = ($x_id <=> $y_id);
   }

   $n
}

sub add_parent_if_required{
   local($label) = @_;

   local($parent) = &gls_get_parent($label);

   if ($parent)
   {
      local($type) = &gls_get_type($parent);

      # does this parent have a backlink?

      for my $key (keys %{$glossary{$type}})
      {
         return if $key=~/^$parent###\d+$/;
      }

      # none found, so add empty one

      my $id = ++$global{'max_id'};

      $glossary{$type}{"$parent###$id"} = '';
      $glossary_entry{$type}{"$parent###$id"} = $parent;

      # check if parent also has a parent

      &add_parent_if_required($parent);
   }
}

sub add_real_gls{
   local($type) = @_;
   print "\nDoing glossary '$type' ...";
   local($key, $str, @keys, $thisglsentry, $level, $count,
   $previous, $current, $id, $linktext, $delimN);

   $TITLE = $gls_toctitle{$type};

   local($oldstyle) = $CURRENT_STYLE;

   if ($gls_style{$type})
   {
      &set_glossarystyle($gls_style{$type});
   }

   # add any parent entries that haven't been referenced

   for my $key (keys %{$glossary{$type}})
   {
      my $label = $key;
      $label =~ s/###\d+$//o; # Remove the unique id's

      &add_parent_if_required($label);
   }

   @keys = keys %{$glossary{$type}};

   @keys = sort gloskeysort @keys;

   $level = 0;

   $delimN = $delimN{$type};

   $previous = '';

   local($previousentry) = '';

   my $glossaryentryfield = '';

   my $previouscat = '';

   local ($entry);

   foreach $key (@keys)
   {
      $current = $key;
      $current =~ s/\#\#\#\d+$//o; # Remove the unique id's

      my $issame = ($current eq $previous ? 1 : 0);

      $previous = $current;

      $entry = $glossary_entry{$type}{$key};

      unless ($issame)
      {
         if ($glossaryentryfield)
         {
            $id = ++$global{'max_id'};

            my $level = &gls_get_level($previousentry);

            if ($level > 0)
            {
              my $id2 = ++$global{'max_id'};

              $thisglsentry .=
                 "\\glossarysubentryfield $OP$id2$CP$level$OP$id2$CP$glossaryentryfield$OP$id$CP$linktext$OP$id$CP";
            }
            else
            {
              $thisglsentry .=
                 "\\glossaryentryfield $glossaryentryfield$OP$id$CP$linktext$OP$id$CP";
            }

            $glossaryentryfield = '';
         }

         $linktext = '';

         my $currentcat = substr(&gls_get_sort($current), 0, 1);

         if ($currentcat=~/[a-zA-Z]/)
         {
            $currentcat = uc($currentcat);
         }
         elsif ($currentcat=~/[0-9]/)
         {
            $currentcat = 'glsnumbers';
         }
         else
         {
            $currentcat = 'glssymbols';
         }

         unless ($previouscat eq $currentcat)
         {
            $id = ++$global{'max_id'};
            $thisglsentry .= "\\glsgroupheading$OP$id$CP$currentcat$OP$id$CP";

            $previouscat = $currentcat;
         }
      }

      $previousentry = $entry;

      # Back ref

      if ($gls_nonumberlist{$type})
      {
         $linktext = '';
      }
      elsif ($glossary{$type}{$key})
      {
         $id = ++$global{'max_id'};

         $linktext .= $delimN if ($linktext);

         $linktext .= "$glossary{$type}{$key}\\$glossary_format{$type}{$key}${OP}$id${CP}$glossary_linktext{$type}{$key}${OP}$id${CP}</A>";

      }

      unless ($issame)
      {
         $id = ++$global{'max_id'};
         local($name) = &translate_commands(
            "\\glsnamefont $OP$id$CP$glsentry{$entry}{name}$OP$id$CP");

         local($symbol) = ($glsentry{$entry}{'symbol'} ?
                        " $glsentry{$entry}{symbol}" : '');

         $id = ++$global{'max_id'};
         my $id2 = ++$global{'max_id'};
         my $id3 = ++$global{'max_id'};
         my $id4 = ++$global{'max_id'};

         $glossaryentryfield = "$OP$id$CP$entry$OP$id$CP" # label
           . "$OP$id2$CP$name$OP$id2$CP" # name
           . "$OP$id3$CP$glsentry{$entry}{description}$OP$id3$CP" # description
           . "$OP$id4$CP$symbol$OP$id4$CP" # symbol
      }

   }

   if ($glossaryentryfield and $entry)
   {
      my $level = &gls_get_level($entry);

      if ($level > 0)
      {
        my $id2 = ++$global{'max_id'};

        $thisglsentry .=
           "\\glossarysubentryfield $OP$id2$CP$level$OP$id2$CP$glossaryentryfield$OP$id$CP$linktext$OP$id$CP";
      }
      else
      {
         $id = ++$global{'max_id'};
         $thisglsentry .=
            "\\glossaryentryfield $glossaryentryfield$OP$id$CP$linktext$OP$id$CP";
      }
   }

   $str = &do_env_theglossary($thisglsentry) . &translate_commands("\\glossarypostamble");

   if ($gls_style{$type})
   {
      &set_glossarystyle($oldstyle);
   }

   s/$gls_mark{$type}/$preglossary\n$str\n/s;
}

sub do_cmd_glstarget{
  local($_) = @_;

  local($id, $label, $text);

  $label = &missing_braces unless
   s/$next_pair_pr_rx/$id=$1;$label=$2;''/eo;

  $text = &missing_braces unless
   s/$next_pair_pr_rx/$id=$1;$text=$2;''/eo;

  "<A NAME=\"gls:$label\">$text</A>$_";
}

sub do_cmd_newglossarystyle{
   local($_) = @_;

   local($id,$style,$defs);

   $style = &missing_braces unless
     s/$next_pair_rx/$id=$1;$style=$2;''/eo;

   $defs = &missing_braces unless
     s/$next_pair_rx/$id=$1;$defs=$2;''/eo;

   $glossary_style{$style} = $defs;

   $_;
}

sub do_cmd_glossarystyle{
   local($_) = @_;

   local($id,$style);

   $style = &missing_braces unless
     s/$next_pair_pr_rx/$id=$1;$style=$2;''/eo;

   &set_glossarystyle($style);

   $_;
}

sub set_glossarystyle{
   local($style) = @_;

   $CURRENT_STYLE = $style;

   if ($glossary_style{$style})
   {
      local($_) = $glossary_style{$style};

      s/$O(\d+)$C/$OP$1$CP/g;

      &translate_commands($_);
   }
   else
   {
      my $cmd_sub = "set_glossarystyle_$style";

      if (defined(&$cmd_sub))
      {
         &$cmd_sub();
      }
      else
      {
         &write_warnings("Unknown glossary style '$style', defaulting to 'altlist'");
         &set_glossarystyle_altlist();

         $CURRENT_STYLE = 'altlist';
      }
   }

}

sub do_cmd_glspar{ "<P>".$_[0]; }

sub do_cmd_glossaryheader{
  local($_) = @_;
  $_
}

sub do_cmd_glsentryitem{
  local($_) = @_;

  local($id, $label);

  $label = &missing_braces unless
     s/$next_pair_pr_rx/$id=$1,$label=$2;''/eo;

  $_
}

sub do_cmd_glssubentryitem{
  local($_) = @_;

  local($id, $label);

  $label = &missing_braces unless
     s/$next_pair_pr_rx/$id=$1,$label=$2;''/eo;

  $_
}

sub do_cmd_glsgroupheading{
  local($_) = @_;

  local($id, $heading);

  $heading = &missing_braces unless
   s/$next_pair_pr_rx/$id=$1,$heading=$2;''/eo;

  $_;
}

sub do_cmd_glossaryentryfield{
   local($_) = @_;

   local($id, $label, $name, $desc, $symbol, $backlink);

   $label = &missing_braces unless
     s/$next_pair_pr_rx/$id=$1;$label=$2;''/eo;

   $name = &missing_braces unless
     s/$next_pair_pr_rx/$id=$1;$name=$2;''/eo;

   $desc = &missing_braces unless
     s/$next_pair_pr_rx/$id=$1;$desc=$2;''/eo;

   $symbol = &missing_braces unless
     s/$next_pair_pr_rx/$id=$1;$symbol=$2;''/eo;

   $backlink = &missing_braces unless
     s/$next_pair_pr_rx/$id=$1;$backlink=$2;''/eo;

   local($id2) = ++$global{'max_id'};

   "\\glstarget $OP$id$CP$label$OP$id$CP$OP$id2$CP$name$OP$id2$CP\n$desc $backlink\n$_";
}

sub do_cmd_glossarysubentryfield{
   local($_) = @_;

   local($id, $level, $label, $name, $desc, $symbol, $backlink);

   $level = &missing_braces unless
     s/$next_pair_pr_rx/$id=$1;$level=$2;''/eo;

   $label = &missing_braces unless
     s/$next_pair_pr_rx/$id=$1;$label=$2;''/eo;

   $name = &missing_braces unless
     s/$next_pair_pr_rx/$id=$1;$name=$2;''/eo;

   $desc = &missing_braces unless
     s/$next_pair_pr_rx/$id=$1;$desc=$2;''/eo;

   $symbol = &missing_braces unless
     s/$next_pair_pr_rx/$id=$1;$symbol=$2;''/eo;

   $backlink = &missing_braces unless
     s/$next_pair_pr_rx/$id=$1;$backlink=$2;''/eo;

   local($id2) = ++$global{'max_id'};

   "\\glstarget $OP$id$CP$label$OP$id$CP$OP$id2$CP$name$OP$id2$CP\n$desc $backlink\n$_";
}

sub do_env_theglossary{
  local($_) = @_;

   &translate_commands($_);
}

sub set_glossarystyle_altlist{
  eval(<<'END_STYLE');
  sub do_cmd_glossaryheader{
    local($_) = @_;
    $_
  }

  sub do_cmd_glsgroupheading{
     local($_) = @_;

     local($id, $heading);

     $heading = &missing_braces unless
      s/$next_pair_pr_rx/$id=$1,$heading=$2;''/eo;

    $_
  }

  sub do_cmd_glossaryentryfield{
     local($_) = @_;

     local($id, $id2, $id3, $id4, $id5, $label, $name, $desc, $symbol, $backlink);

     $label = &missing_braces unless
       s/$next_pair_pr_rx/$id=$1;$label=$2;''/eo;

     $name = &missing_braces unless
       s/$next_pair_pr_rx/$id2=$1;$name=$2;''/eo;

     $desc = &missing_braces unless
       s/$next_pair_pr_rx/$id3=$1;$desc=$2;''/eo;

     $symbol = &missing_braces unless
       s/$next_pair_pr_rx/$id4=$1;$symbol=$2;''/eo;

     $backlink = &missing_braces unless
       s/$next_pair_pr_rx/$id5=$1;$backlink=$2;''/eo;

     "<DT>\\glstarget $OP$id$CP$label$OP$id$CP$OP$id2$CP$name$OP$id2$CP\n<DD>"
     . "$desc\\glspostdescription\\space $backlink$_";
  }

  sub do_cmd_glossarysubentryfield{
     local($_) = @_;

     local($id, $id2, $id3, $id4, $id5, $id6, $level,
       $label, $name, $desc, $symbol, $backlink);

     $level = &missing_braces unless
       s/$next_pair_pr_rx/$id=$1;$level=$2;''/eo;

     $label = &missing_braces unless
       s/$next_pair_pr_rx/$id2=$1;$label=$2;''/eo;

     $name = &missing_braces unless
       s/$next_pair_pr_rx/$id3=$1;$name=$2;''/eo;

     $desc = &missing_braces unless
       s/$next_pair_pr_rx/$id4=$1;$desc=$2;''/eo;

     $symbol = &missing_braces unless
       s/$next_pair_pr_rx/$id5=$1;$symbol=$2;''/eo;

     $backlink = &missing_braces unless
       s/$next_pair_pr_rx/$id6=$1;$backlink=$2;''/eo;

     "<P>\\glssubentryitem $OP$id$CP$label$OP$id$CP"
     ."\\glstarget $OP$id2$CP$label$OP$id2$CP$OP$id3$CP$name$OP$id3$CP"
     ."$desc\\glspostdescription\\space $backlink\n$_";
  }

  sub do_env_theglossary{
    local($_) = @_;

     "<DL>".&translate_commands("\\glossaryheader $_")."</DL>";
  }
END_STYLE
}

sub set_glossarystyle_inline{
  eval(<<'END_STYLE');
  sub do_cmd_glossaryheader{
    local($_) = @_;
    $_
  }

  sub do_cmd_glsgroupheading{
    local($_) = @_;

    local($id, $heading);

    $heading = &missing_braces unless
     s/$next_pair_pr_rx/$id=$1,$heading=$2;''/eo;

    $_;
  }

  sub do_cmd_glossaryentryfield{
     local($_) = @_;

     local($id, $id2, $id3, $id4, $id5, $label, $name, $desc, $symbol, $backlink);

     $label = &missing_braces unless
       s/$next_pair_pr_rx/$id=$1;$label=$2;''/eo;

     $name = &missing_braces unless
       s/$next_pair_pr_rx/$id2=$1;$name=$2;''/eo;

     $desc = &missing_braces unless
       s/$next_pair_pr_rx/$id3=$1;$desc=$2;''/eo;

     $symbol = &missing_braces unless
       s/$next_pair_pr_rx/$id4=$1;$symbol=$2;''/eo;

     $backlink = &missing_braces unless
       s/$next_pair_pr_rx/$id5=$1;$backlink=$2;''/eo;

     local($field) = "\\glsinlinedopostchild $glsinlinesep";

     $field .= "\\glsentryitem $OP$id$CP$label$OP$id$CP"
             . "\\glsinlinenameformat $OP$id2$CP$label$OP$id2$CP$OP$id3$CP$name$OP$id3$CP";

     $id3 = ++$global{'max_id'};

     if ($desc)
     {
       $field .=
           "\\glsinlinedescformat $OP$id3$CP$desc$OP$id3$CP"
          ."$OP$id4$CP$symbol$OP$id4$CP"
          ."$OP$id5$CP$backlink$OP$id5$CP";
     }
     else
     {
       $field .=
           "\\glsinlineemptydescformat "
          ."$OP$id4$CP$symbol$OP$id4$CP"
          ."$OP$id5$CP$backlink$OP$id5$CP";
     }

# TODO : check if has children

     local($haschildren) = 0;

     if ($haschildren)
     {
       $field .= "\\glsresetsubentrycounter "
               . "\\glsinlineparentchildseparator "
               . "\\glsinlinepostchild ";
     }

    $glsinlinesep = &translate_commands("\\glsinlineseparator ")
       unless $glsinlinesep;

     $field.$_;
  }

  sub do_cmd_glossarysubentryfield{
     local($_) = @_;

     local($id, $id2, $id3, $id4,$id5,$id6,$level,
       $label, $name, $desc, $symbol, $backlink);

     $level = &missing_braces unless
       s/$next_pair_pr_rx/$id=$1;$level=$2;''/eo;

     $label = &missing_braces unless
       s/$next_pair_pr_rx/$id2=$1;$label=$2;''/eo;

     $name = &missing_braces unless
       s/$next_pair_pr_rx/$id3=$1;$name=$2;''/eo;

     $desc = &missing_braces unless
       s/$next_pair_pr_rx/$id4=$1;$desc=$2;''/eo;

     $symbol = &missing_braces unless
       s/$next_pair_pr_rx/$id5=$1;$symbol=$2;''/eo;

     $backlink = &missing_braces unless
       s/$next_pair_pr_rx/$id6=$1;$backlink=$2;''/eo;

     "\\glsinlinesubnameformat $OP$id$CP$label$OP$id$CP$OP$id2$CP$name$OP$id2$CP"
     ."\\glssubentryitem $OP$id3$CP$label$OP$id3$CP"
     ."\\glsinlinesubdescformat $OP$id4$CP$desc$OP$id4$CP$OP$id5$CP$symbol$OP$id5$CP$OP$id6$CP$backlink$OP$id6$CP"
     .$_;
  }

  sub do_env_theglossary{
    local($_) = @_;

    $glsinlinesep = '';

     &translate_commands("\\glossaryheader $_\\glspostinline ");
  }
END_STYLE
}

local($glsinlinesep,$glsinlinepostchild);

sub do_cmd_glsinlineseparator{
  local($_) = @_;

  "; $_";
}

sub do_cmd_glsinlinedopostchild{
  local($_) = @_;

  $_;
}

sub do_cmd_glspostdescription{
  local($_) = @_;

  $GLOSSARY_END_DESCRIPTION.$_;
}

sub do_cmd_glspostinline{
  local($_) = @_;

  &translate_commands("\\glspostdescription\\space ").$_;
}

sub do_cmd_glsinlinepostchild{
  local($_) = @_;

  $_;
}

sub do_cmd_glsinlineparentchildseparator{
  local($_) = @_;

  ": $_";
}

sub do_cmd_glsinlinesubseparator{
  local($_) = @_;

  ", $_";
}

sub do_cmd_glsinlinenameformat{
  &do_cmd_glstarget(@_);
}

sub do_cmd_glsinlinedescformat{
  local($_) = @_;

  local($id, $desc, $symbol, $backlinks);

  $desc = &missing_braces unless
    s/$next_pair_pr_rx/$id=$1,$desc=$2;''/eo;

  $symbol = &missing_braces unless
    s/$next_pair_pr_rx/$id=$1,$symbol=$2;''/eo;

  $backlinks = &missing_braces unless
    s/$next_pair_pr_rx/$id=$1,$backlinks=$2;''/eo;

  "\\space $desc$_";
}

sub do_cmd_glsinlineemptydescformat{
  local($_) = @_;

  local($id, $symbol, $backlinks);

  $symbol = &missing_braces unless
    s/$next_pair_pr_rx/$id=$1,$symbol=$2;''/eo;

  $backlinks = &missing_braces unless
    s/$next_pair_pr_rx/$id=$1,$backlinks=$2;''/eo;

  $_;
}

sub do_cmd_glsinlinesubnameformat{
  local($_) = @_;

  local($id, $id2, $label, $name);

  $label = &missing_braces unless
    s/$next_pair_pr_rx/$id=$1,$label=$2;''/eo;

  $name = &missing_braces unless
    s/$next_pair_pr_rx/$id2=$1,$name=$2;''/eo;

  "\\glstarget $OP$id$CP$label$OP$id$CP$OP$id2$CP$OP$id2$CP$_";
}

sub do_cmd_glsinlinesubdescformat{
  local($_) = @_;

  local($id, $desc, $symbol, $backlinks);

  $desc = &missing_braces unless
    s/$next_pair_pr_rx/$id=$1,$desc=$2;''/eo;

  $symbol = &missing_braces unless
    s/$next_pair_pr_rx/$id=$1,$symbol=$2;''/eo;

  $backlinks = &missing_braces unless
    s/$next_pair_pr_rx/$id=$1,$backlinks=$2;''/eo;

  "$desc$_";
}

sub set_depth_levels {
    # Sets $outermost_level
    local($level);
    # scan the document body, not the preamble, for use of sectioning commands
    my ($contents) = $_;
    if ($contents =~ /\\begin\s*((?:$O|$OP)\d+(?:$C|$CP))document\1|\\startdocument/s) {
$contents = $';
    }
    foreach $level ("part", "chapter", "section", "subsection",
    "subsubsection", "paragraph") {
last if (($outermost_level) = $contents =~ /\\($level)$delimiter_rx/);
last if (($outermost_level) = $contents =~ /\\endsegment\s*\[\s*($level)\s*\]/s);
if ($contents =~ /\\segment\s*($O\d+$C)[^<]+\1\s*($O\d+$C)\s*($level)\s*\2/s)
{ $outermost_level = $3; last };
    }
    $level = ($outermost_level ? $section_commands{$outermost_level} :
      do {$outermost_level = 'section'; 3;});

    if ($REL_DEPTH && $MAX_SPLIT_DEPTH) {
$MAX_SPLIT_DEPTH = $level + $MAX_SPLIT_DEPTH;
    } elsif (!($MAX_SPLIT_DEPTH)) { $MAX_SPLIT_DEPTH = 1 };

    %unnumbered_section_commands = (
          'tableofcontents', $level
, 'listoffigures', $level
, 'listoftables', $level
, 'bibliography', $level
, 'textohtmlindex', $level
, 'textohtmlglossary', $level
, 'textohtmlglossaries', $level
        , %unnumbered_section_commands
        );

    %section_commands = (
  %unnumbered_section_commands
        , %section_commands
        );
}

sub add_bbl_and_idx_dummy_commands {
    local($id) = $global{'max_id'};

    s/([\\]begin\s*$O\d+$C\s*thebibliography)/$bbl_cnt++; $1/eg;
    ## if ($bbl_cnt == 1) {
s/([\\]begin\s*$O\d+$C\s*thebibliography)/$id++; "\\bibliography$O$id$C$O$id$C $1"/geo;
    #}
    $global{'max_id'} = $id;
    s/([\\]begin\s*$O\d+$C\s*theindex)/\\textohtmlindex $1/o;
    s/[\\]printindex/\\textohtmlindex /o;
    &add_gls_dummy_commands;
    &lib_add_bbl_and_idx_dummy_commands() if defined(&lib_add_bbl_and_idx_dummy_commands);
}

sub add_gls_dummy_commands{
   s/[\\]printglossary/\\textohtmlglossary/sg;
   s/[\\]printglossaries/\\textohtmlglossaries/sg;
}

sub get_firstkeyval{
   local($key,$_) = @_;
   local($value);

   s/\b$key\s*=$OP(\d+)$CP(.*)$OP\1$CP\s*(,|$)/$value=$2;','/es;
   undef($value) if $`=~/\b$key\s*=/;

   unless (defined($value))
   {
      s/(^|,)\s*$key\s*=\s*([^,]*)\s*(,|$)/,/s;
      $value=$2;
   }

   ($value,$_);
}

# need to get the value of the last key of a given name
# in the event of multiple occurrences.
sub get_keyval{
   local($key,$_) = @_;
   local($value);

   while (/\b$key\s*=/g)
   {
      ($value,$_) = &get_firstkeyval($key, $_);
      last unless defined($value);
   }

   ($value,$_);
}

sub get_boolval{
   local($key,$_) = @_;
   local($value);

   while (/\b$key\s*(?:=(true|false))?\b/g)
   {
     $value = ($1 ? $1 : 'true');
   }

   ($value eq 'true' ? 1 : 0, $_);
}

# This is modified from do_cmd_textohtmlindex

sub do_cmd_textohtmlglossary{
   local($_) = @_;

   local($keyval,$pat) = &get_next_optional_argument;

   local($type,$title,$toctitle,$style,$nonumberlist);

   $nonumberlist = 'default';

   ($type,$keyval) = &get_keyval('type', $keyval);
   ($title,$keyval) = &get_keyval('title', $keyval);
   ($toctitle,$keyval) = &get_keyval('toctitle', $keyval);
   ($style,$keyval) = &get_keyval('style', $keyval);
   ($nonumberlist,$keyval) = &get_boolval('nonumberlist', $keyval);

   &make_textohtmlglossary($type,$toctitle,$title,$style,$nonumberlist).$_;
}

# add_real_gls does the actual glossary
sub make_textohtmlglossary{
   local($type,$toctitle,$title,$style,$nonumberlist) = @_;

   unless (defined($type)) {$type = 'main';}

   unless (defined $gls_mark{$type})
   {
      &write_warnings("glossary type '$type' not implemented");
   }

   if ($style)
   {
      $gls_style{$type} = $style;
   }

   $toctitle = $gls_toctitle{$type} unless ($toctitle or $title);

   $title = $gls_title{$type} unless ($title);
   $toctitle = $title unless ($toctitle);

   $gls_toctitle{$type} = $toctitle;

   $gls_nonumberlist{$type} = $nonumberlist unless ($nonumberlist eq 'default');

   $toc_sec_title = $toctitle;
   $glsfile{$type} = $CURRENT_FILE;

   if (defined($frame_main_suffix))
   {
      $glsfile{$type}=~s/$frame_main_suffix/$frame_body_suffix/;
   }

   $TITLE=&translate_commands($toctitle);

   if (%glossary_labels) { &make_glossary_labels(); }

   if (($SHORT_INDEX) && (%glossary_segment))
   {
      &make_preglossary();
   }
   else
   {
      $preglossary = &translate_commands("\\glossarypreamble");
   }

   local $idx_head = $section_headings{'textohtmlindex'};
   local($heading) = join(''
        , &make_section_heading($title, $idx_head)
        , $gls_mark{$type} );
   local($pre,$post) = &minimize_open_tags($heading);

   join('',"<BR>\n" , $pre);
}

sub do_cmd_textohtmlglossaries{
   local($_) = @_;

   foreach $type (keys %gls_mark)
   {
      $id = ++$global{'max_id'};
      $_ = &make_textohtmlglossary($type,$gls_title{'main'}).$_;
   }

   $_;
}

sub make_glossary_labels {
    local($key, @keys);
    @keys = keys %glossary_labels;
    foreach $key (@keys) {
        if (($ref_files{$key}) && !($ref_files{$key} eq "$glsfile{'main'}")) {
            local($tmp) = $ref_files{$key};
            &write_warnings("\nmultiple label $key , target in $glsfile{'main'} masks $tmp ");
        }
        $ref_files{$key} .= $glsfile{'main'};
    }
}

sub make_preglossary{ &make_real_preglossary }
sub make_real_preglossary{
    local($key, @keys, $head, $body);
    $head = "<HR>\n<H4>Legend:</H4>\n<DL COMPACT>";
    @keys = keys %glossary_segment;
    foreach $key (@keys) {
        local($tmp) = "segment$key";
        $tmp = $ref_files{$tmp};
        $body .= "\n<DT>$key<DD>".&make_named_href('',$tmp,$glossary_segment{$key});
    }
    $preglossary = join('', $head, $body, "\n</DL>") if ($body);
}

sub do_cmd_glossary { &do_real_glossary(@_) }
sub do_real_glossary {
   local($_) = @_;
   local($type) = "main";
   local($anchor,$entry);

   local($type,$pat) = &get_next_optional_argument;

   $entry = &missing_braces unless
           (s/$next_pair_pr_rx//o&&($entry=$2));

   $anchor = &make_glossary_entry($entry,$anchor_invisible_mark,$type);

   join('', $anchor, $_);
}

sub make_glossary_entry { &make_real_glossary_entry(@_) }
sub make_real_glossary_entry {
    local($entry,$text,$type) = @_;
    local($this_file) = $CURRENT_FILE;

    $TITLE = $saved_title
       if (($saved_title)&&(!($TITLE)||($TITLE eq $default_title)));

    # Save the reference
    local($str) = "$label###" . ++$global{'max_id'}; # Make unique

    local($id) = ++$glsentry{$entry}{'maxid'};
    local($glsanchor)="gls:$entry$id";

    local($target) = $frame_body_name;

    if (defined($frame_main_suffix))
    {
       $this_file=~s/$frame_main_suffix/$frame_body_suffix/;
    }

    $glossary{$type}{$str} .= &make_half_href($this_file."#$glsanchor");
    $glossary_format{$type}{$str} = $GLSCURRENTFORMAT;
    $glossary_entry{$type}{$str} = $entry;
    $glossary_linktext{$type}{$str} = $TITLE;

    local($mark) = $gls_file_mark{$type};

    $mark = &get_gls_file_mark($type, $entry) if (defined(&get_gls_file_mark));

    $text = &translate_commands($text);

    if (defined($frame_foot_name))
    {
       "<A HREF=\"$mark#gls:$entry\" NAME=\"$glsanchor\" TARGET=\"$frame_foot_name\">$text<\/A>";
    }
    else
    {
       "<A HREF=\"$mark#gls:$entry\" NAME=\"$glsanchor\">$text<\/A>";
    }
}

sub make_real_glossary_entry_no_backlink {
    local($entry,$text,$type) = @_;
    local($this_file) = $CURRENT_FILE;

    local($target) = $frame_body_name;

    if (defined($frame_main_suffix))
    {
       $this_file=~s/$frame_main_suffix/$frame_body_suffix/;
    }

    local($mark) = $gls_file_mark{$type};

    $mark = &get_gls_file_mark($type, $entry) if (defined(&get_gls_file_mark));

    $text = &translate_commands($text);

    if (defined($frame_foot_name))
    {
       "<A HREF=\"$mark#gls:$entry\" NAME=\"$glsanchor\" TARGET=\"$frame_foot_name\">$text<\/A>";
    }
    else
    {
       "<A HREF=\"$mark#gls:$entry\" >$text<\/A>";
    }
}

sub do_cmd_newglossary{
   local($_) = @_;
   local($type,$out,$in,$opt,$pat,$title);

   ($opt,$pat) = &get_next_optional_argument;

   $type = &missing_braces unless
           (s/$next_pair_pr_rx//o&&($type=$2));
   $in = &missing_braces unless
           (s/$next_pair_pr_rx//o&&($in=$2));
   $out = &missing_braces unless
           (s/$next_pair_pr_rx//o&&($out=$2));
   $title = &missing_braces unless
           (s/$next_pair_pr_rx//o&&($title=$2));

   ($opt,$pat) = &get_next_optional_argument;

   &make_newglossarytype($type, $title);

   $_;
}

sub make_newglossarytype{
   local($type, $title) = @_;

   $gls_mark{$type} = "<tex2html_gls_${type}_mark>";
   $gls_file_mark{$type} = "<tex2html_gls_${type}_file_mark>";
   $gls_title{$type} = $title;
   $gls_toctitle{$type} = $title;
   $delimN{$type} = ", ";
   $glsnumformat{$type} = $GLSCURRENTFORMAT;
   @{$gls_entries{$type}} = ();
   $gls_displayfirst{$type} = "glsdisplayfirst";
   $gls_display{$type} = "glsdisplay";
   $gls_nonumberlist{$type} = $gls_nonumberlist{'main'};
}

sub do_cmd_glsdisplay{
   local($_) = @_;
   local($text,$description,$symbol,$insert);

   $text = &missing_braces unless
        (s/$next_pair_pr_rx/$text=$2;''/eo);

   $description = &missing_braces unless
        (s/$next_pair_pr_rx/$description=$2;''/eo);

   $symbol = &missing_braces unless
        (s/$next_pair_pr_rx/$symbol=$2;''/eo);

   $insert = &missing_braces unless
        (s/$next_pair_pr_rx/$insert=$2;''/eo);

   "$text$insert" . $_;
}

sub do_cmd_glsdisplayfirst{
   local($_) = @_;
   local($text,$description,$symbol,$insert);

   $text = &missing_braces unless
        (s/$next_pair_pr_rx/$text=$2;''/eo);

   $description = &missing_braces unless
        (s/$next_pair_pr_rx/$description=$2;''/eo);

   $symbol = &missing_braces unless
        (s/$next_pair_pr_rx/$symbol=$2;''/eo);

   $insert = &missing_braces unless
        (s/$next_pair_pr_rx/$insert=$2;''/eo);

   "$text$insert" . $_;
}

sub gls_get_displayfirst{
   local($type) = @_;
   local($display)= $gls_displayfirst{$type};

   if (not defined($display))
   {
      &write_warnings("Glossary '$type' is not defined");
      $display='';
   }
   elsif ($display eq '')
   {
      &write_warnings("glsdisplayfirst not set for glossary '$type'");
   }
   else
   {
      $display = "\\$display ";
   }

   $display;
}

sub gls_get_display{
   local($type) = @_;
   local($display)= $gls_display{$type};

   if (not defined($display))
   {
      &write_warnings("Glossary '$type' is not defined");
      $display = '';
   }
   elsif ($display eq '')
   {
      &write_warnings("glsdisplay not set for glossary '$type'");
   }
   else
   {
      $display = "\\$display ";
   }

   $display;
}

sub do_cmd_glsnamefont{
   local($_) = @_;
   local($text);

   $text = &missing_braces unless
        (s/$next_pair_pr_rx/$text=$2;''/eo);

   "<B>$text</B>$_";
}

sub do_cmd_newacronym{
   local($_) = @_;
   local($label,$abbrev,$long,$opt,$shortplural,$longplural);

   ($opt,$pat) = &get_next_optional_argument;

   $label = &missing_braces unless
        (s/$next_pair_pr_rx/$label=$2;''/eo);
   $abbrv = &missing_braces unless
        (s/$next_pair_pr_rx/$abbrv=$2;''/eo);
   $long = &missing_braces unless
        (s/$next_pair_pr_rx/$long=$2;''/eo);

   ($longplural,$opt) = &get_keyval('longplural', $opt);
   ($shortplural,$opt) = &get_keyval('shortplural', $opt);

   $longplural = $long.'s' unless ($longplural);
   $shortplural = $abbrv.'s' unless ($shortplural);

   local($cmd) = "\\newglossaryentry";
   local($id);
   $id = ++$global{'max_id'};
   $cmd .= "$OP$id$CP$label$OP$id$CP";
   $id = ++$global{'max_id'};
   local($entry) = "type=$OP$id$CP\\acronymtype$OP$id$CP,";
   $id = ++$global{'max_id'};
   $entry .= "name=$OP$id$CP$abbrv$OP$id$CP,";
   $id = ++$global{'max_id'};
   $entry .= "description=$OP$id$CP$long$OP$id$CP,";
   $id = ++$global{'max_id'};
   $entry .= "text=$OP$id$CP$abbrv$OP$id$CP,";
   $id = ++$global{'max_id'};
   $entry .= "first=$OP$id$CP$long ($abbrv)$OP$id$CP,";
   $id = ++$global{'max_id'};
   $entry .= "plural=$OP$id$CP$shortplural$OP$id$CP,";
   $id = ++$global{'max_id'};
   $entry .= "firstplural=$OP$id$CP$longplural ($shortplural)$OP$id$CP";

   $id = ++$global{'max_id'};
   $cmd .= "$OP$id$CP$entry,$opt$OP$id$CP";

   &translate_commands($cmd).$_;
}

sub gls_entry_init{
   local($label, $type, $name, $desc) = @_;

   %{$glsentry{$label}} =
     ( type => $type,
       name => $name,
       'sort' => $name,
       description => $desc,
       text => $name,
       first => $name,
       plural => "${name}s",
       firstplural => "${name}s",
       symbol => '',
       flag => 0,
       maxid => 0,
       level => 0,
       parent => ''
     );

   $#{@{$glsentry{$label}{children}}} = -1;

   $glsentry{$label};
}

sub gls_get_type{
   local($label) = @_;
   local($type) = '';

   if (&gls_entry_defined($label))
   {
      $type = $glsentry{$label}{'type'};
   }
   else
   {
      &write_warnings("gls_get_type: glossary entry '$label' has not been defined");
   }

   $type;
}

sub gls_set_type{
   local($label, $type) = @_;

   if (&gls_entry_defined($label))
   {
      $glsentry{$label}{'type'} = $type;
   }
   else
   {
      &write_warnings("gls_set_type: glossary entry '$label' has not been defined");
   }
}

sub gls_get_name{
   local($label) = @_;
   local($name) = '';

   if (&gls_entry_defined($label))
   {
      $name = $glsentry{$label}{'name'};
   }
   else
   {
      &write_warnings("gls_get_name: glossary entry '$label' has not been defined");
   }

   $name;
}

sub gls_set_name{
   local($label, $name) = @_;

   if (&gls_entry_defined($label))
   {
      $glsentry{$label}{'name'} = $name;
   }
   else
   {
      &write_warnings("gls_set_name: glossary entry '$label' has not been defined");
   }
}

sub gls_get_description{
   local($label) = @_;
   local($description) = '';

   if (&gls_entry_defined($label))
   {
      $description = $glsentry{$label}{'description'};
   }
   else
   {
      &write_warnings("gls_get_description: glossary entry '$label' has not been defined");
   }

   $description;
}

sub gls_set_description{
   local($label, $description) = @_;

   if (&gls_entry_defined($label))
   {
      $glsentry{$label}{'description'} = $description;
   }
   else
   {
      &write_warnings("gls_set_description: glossary entry '$label' has not been defined");
   }
}

sub gls_get_symbol{
   local($label) = @_;
   local($symbol) = '';

   if (&gls_entry_defined($label))
   {
      $symbol = $glsentry{$label}{'symbol'};
   }
   else
   {
      &write_warnings("gls_get_symbol: glossary entry '$label' has not been defined");
   }

   $symbol;
}

sub gls_set_symbol{
   local($label, $symbol) = @_;

   if (&gls_entry_defined($label))
   {
      $glsentry{$label}{'symbol'} = $symbol;
   }
   else
   {
      &write_warnings("gls_set_symbol: glossary entry '$label' has not been defined");
   }
}

sub gls_get_sort{
   local($label) = @_;
   local($sort) = '';

   if (&gls_entry_defined($label))
   {
      $sort = $glsentry{$label}{'sort'};
   }
   else
   {
      &write_warnings("gls_get_sort: glossary entry '$label' has not been defined");
   }

   $sort;
}

sub gls_set_sort{
   local($label, $sort) = @_;

   if (&gls_entry_defined($label))
   {
      $glsentry{$label}{'sort'} = $sort;
   }
   else
   {
      &write_warnings("gls_set_sort: glossary entry '$label' has not been defined");
   }
}

sub gls_get_text{
   local($label) = @_;
   local($text) = '';

   if (&gls_entry_defined($label))
   {
      $text = $glsentry{$label}{'text'};
   }
   else
   {
      &write_warnings("gls_get_text: glossary entry '$label' has not been defined");
   }

   $text;
}

sub gls_set_text{
   local($label, $text) = @_;

   if (&gls_entry_defined($label))
   {
      $glsentry{$label}{'text'} = $text;
   }
   else
   {
      &write_warnings("gls_set_text: glossary entry '$label' has not been defined");
   }
}

sub gls_get_plural{
   local($label) = @_;
   local($plural) = '';

   if (&gls_entry_defined($label))
   {
      $plural = $glsentry{$label}{'plural'};
   }
   else
   {
      &write_warnings("gls_get_plural: glossary entry '$label' has not been defined");
   }

   $plural;
}

sub gls_set_plural{
   local($label, $plural) = @_;

   if (&gls_entry_defined($label))
   {
      $glsentry{$label}{'plural'} = $plural;
   }
   else
   {
      &write_warnings("gls_set_plural: glossary entry '$label' has not been defined");
   }
}

sub gls_get_firstplural{
   local($label) = @_;
   local($firstplural) = '';

   if (&gls_entry_defined($label))
   {
      $firstplural = $glsentry{$label}{'firstplural'};
   }
   else
   {
      &write_warnings("gls_get_firstplural: glossary entry '$label' has not been defined");
   }

   $firstplural;
}

sub gls_set_firstplural{
   local($label, $firstplural) = @_;

   if (&gls_entry_defined($label))
   {
      $glsentry{$label}{'firstplural'} = $firstplural;
   }
   else
   {
      &write_warnings("gls_set_firstplural: glossary entry '$label' has not been defined");
   }
}

sub gls_get_first{
   local($label) = @_;
   local($first) = '';

   if (&gls_entry_defined($label))
   {
      $first = $glsentry{$label}{'first'};
   }
   else
   {
      &write_warnings("gls_get_first: glossary entry '$label' has not been defined");
   }

   $first;
}

sub gls_set_first{
   local($label, $first) = @_;

   if (&gls_entry_defined($label))
   {
      $glsentry{$label}{'first'} = $first;
   }
   else
   {
      &write_warnings("gls_set_first: glossary entry '$label' has not been defined");
   }
}

sub gls_get_parent{
  local($label) = @_;

  local($parent);

  if (&gls_entry_defined($label))
  {
     $parent = $glsentry{$label}{'parent'};
  }
  else
  {
     &write_warnings("gls_get_parent: glossary entry '$label' has not been defined");
  }

  $parent;
}

sub gls_get_level{
   local($label) = @_;

   local($level) = 0;

   if (&gls_entry_defined($label))
   {
      $level = $glsentry{$label}{'level'};
   }
   else
   {
     &write_warnings("gls_get_level: glossary entry '$label' has not been defined");
   }

   $level;
}

sub gls_set_parent{
  local ($label, $parent) = @_;

  if (&gls_entry_defined($label))
  {
     if ($parent)
     {
        if (&gls_entry_defined($parent))
        {
           $glsentry{$label}{'parent'} = $parent;

           push @{$glsentry{$parent}{'children'}}, $label;

           $glsentry{$label}{'level'} = $glsentry{$parent}{'level'}+1;
        }
        else
        {
           &write_warnings("gls_set_parent: parent '$parent' for glossary entry '$label' has not been defined");
        }
     }
     else
     {
        $glsentry{$label}{'parent'} = '';
     }
  }
  else
  {
     &write_warnings("gls_set_parent: glossary entry '$label' has not been defined");
  }
}

sub gls_get_childcount{
   my($label) = @_;

   my($count) = 0;

   if (&gls_entry_defined($label))
   {
      $count = scalar(@{$glsentry{$label}{'children'}});
   }
   else
   {
      &write_warnings("gls_get_childcount: glossary entry '$label' has not been defined");
   }

   $count;
}

sub gls_get_referenced_childcount{
   my($label) = @_;

   my($count) = 0;

   if (&gls_entry_defined($label))
   {
      $count = scalar(grep(($glsentry{$_}{'maxid'} > 0), @{$glsentry{$label}{'children'}}));
   }
   else
   {
      &write_warnings("gls_get_childcount: glossary entry '$label' has not been defined");
   }

   $count;
}

sub gls_set_userkeys{
   local($label, @user) = @_;

   if (&gls_entry_defined($label))
   {
      for (my $idx = 0; $idx < 6; $idx++)
      {
         $glsentry{$label}{"user".($idx+1)} = $user[$idx];
      }
   }
   else
   {
      &write_warnings("gls_set_user: glossary entry '$label' has not been defined");
   }
}

sub gls_set_user{
   local($label, $idx, $text) = @_;

   if (&gls_entry_defined($label))
   {
      $glsentry{$label}{"user$idx"} = $text;
   }
   else
   {
      &write_warnings("gls_set_user: glossary entry '$label' has not been defined");
   }
}

sub gls_set_useri{
   local($label, $text) = @_;

   if (&gls_entry_defined($label))
   {
      $glsentry{$label}{'user1'} = $text;
   }
   else
   {
      &write_warnings("gls_set_useri: glossary entry '$label' has not been defined");
   }
}

sub gls_set_userii{
   local($label, $text) = @_;

   if (&gls_entry_defined($label))
   {
      $glsentry{$label}{'user2'} = $text;
   }
   else
   {
      &write_warnings("gls_set_userii: glossary entry '$label' has not been defined");
   }
}

sub gls_set_useriii{
   local($label, $text) = @_;

   if (&gls_entry_defined($label))
   {
      $glsentry{$label}{'user3'} = $text;
   }
   else
   {
      &write_warnings("gls_set_useriii: glossary entry '$label' has not been defined");
   }
}

sub gls_set_useriv{
   local($label, $text) = @_;

   if (&gls_entry_defined($label))
   {
      $glsentry{$label}{'user4'} = $text;
   }
   else
   {
      &write_warnings("gls_set_useriv: glossary entry '$label' has not been defined");
   }
}

sub gls_set_userv{
   local($label, $text) = @_;

   if (&gls_entry_defined($label))
   {
      $glsentry{$label}{'user5'} = $text;
   }
   else
   {
      &write_warnings("gls_set_userv: glossary entry '$label' has not been defined");
   }
}

sub gls_set_uservi{
   local($label, $text) = @_;

   if (&gls_entry_defined($label))
   {
      $glsentry{$label}{'user6'} = $text;
   }
   else
   {
      &write_warnings("gls_set_uservi: glossary entry '$label' has not been defined");
   }
}

sub gls_get_user{
   local($label, $idx) = @_;
   local($value) = '';

   if (&gls_entry_defined($label))
   {
      $value = $glsentry{$label}{"user".$idx};
   }
   else
   {
      &write_warnings("gls_get_user[$idx]: glossary entry '$label' has not been defined");
   }

   $value;
}

sub gls_used{
   local($label) = @_;
   local($flag) = 0;

   if (&gls_entry_defined($label))
   {
      $flag = $glsentry{$label}{'flag'};
   }
   else
   {
      &write_warnings("gls_used: glossary entry '$label' has not been defined");
   }

   $flag;
}

sub gls_entry_defined{
   local($label) = @_;

   (%{$glsentry{$label}}) ? 1 : 0;
}

sub do_cmd_newglossaryentry{
   local($_) = @_;
   local($label,$name,$description,$symbol,$sort,$text,$first,
     $plural,$firstplural,$type,$keyval,$parent,@user);

   $label = &missing_braces unless
              s/$next_pair_pr_rx/$label=$2;''/eo;

   $keyval = &missing_braces unless
              s/$next_pair_pr_rx/$keyval=$2;''/eo;

   ($name,$keyval) = &get_keyval('name', $keyval);
   ($description,$keyval) = &get_keyval('description', $keyval);
   ($symbol,$keyval) = &get_keyval('symbol', $keyval);
   ($sort,$keyval) = &get_keyval('sort', $keyval);
   ($text,$keyval) = &get_keyval('text', $keyval);
   ($first,$keyval) = &get_keyval('first', $keyval);
   ($firstplural,$keyval) = &get_keyval('firstplural', $keyval);
   ($plural,$keyval) = &get_keyval('plural', $keyval);
   ($type,$keyval) = &get_keyval('type', $keyval);
   ($parent,$keyval) = &get_keyval('parent', $keyval);

   if ($parent and not $name)
   {
     $name = &gls_get_name($parent);
   }

   @user = ();

   for (my $idx = 0; $idx < 6; $idx++)
   {
      ($user[$idx],$keyval) = &get_keyval("user".($idx+1), $keyval);
   }

   if (defined($type))
   {
      $type = &translate_commands($type);
   }
   else
   {
      $type = 'main';
   }

   &gls_entry_init($label, $type, $name, $description);

   &gls_set_symbol($label, defined($symbol)?$symbol:'');

   $sort = "$name $description" unless (defined($sort) and $sort);

   &gls_set_sort($label, $sort);

   $text = $name unless (defined($text) and $text);

   &gls_set_text($label, $text);

   $first = $text unless (defined($first) and $first);

   &gls_set_first($label, $first);

   $plural = "${text}s" unless (defined($plural) and $plural);

   &gls_set_plural($label, $plural);

   $firstplural = "${first}s" unless (defined($firstplural) and $firstplural);

   &gls_set_firstplural($label, $firstplural);

   &gls_set_userkeys($label, @user);

   &gls_set_parent($label, $parent);

   push @{$gls_entries{$type}}, $label;

   $_;
}

sub reset_entry{
   local($label) = @_;

   $glsentry{$label}{'flag'} = 0;
}

sub unset_entry{
   local($label) = @_;

   $glsentry{$label}{'flag'} = 1;
}

sub do_cmd_glsreset{
   local($_) = @_;
   local($label);

   $label = &missing_braces unless
              s/$next_pair_pr_rx/$label=$2;''/eo;

   &reset_entry($label);

   $_;
}

sub do_cmd_glsunset{
   local($_) = @_;
   local($label);

   $label = &missing_braces unless
              s/$next_pair_pr_rx/$label=$2;''/eo;

   &unset_entry($label);

   $_;
}

sub do_cmd_ifglsused{
   local($_) = @_;
   local($label,$true,$false);

   $label = &missing_braces unless
              s/$next_pair_pr_rx/$label=$2;''/eo;

   $true = &missing_braces unless
              s/$next_pair_pr_rx/$true=$2;''/eo;

   $false = &missing_braces unless
              s/$next_pair_pr_rx/$false=$2;''/eo;

   (&gls_used($label) ? $true : $false) . $_;
}

sub do_cmd_ifglsentryexists{
   local($_) = @_;
   local($label,$true,$false);

   $label = &missing_braces unless
              s/$next_pair_pr_rx/$label=$2;''/eo;

   $true = &missing_braces unless
              s/$next_pair_pr_rx/$true=$2;''/eo;

   $false = &missing_braces unless
              s/$next_pair_pr_rx/$false=$2;''/eo;

   (&gls_entry_defined($label) ? $true : $false) . $_;
}

sub gls_add_entry{
   local($type, $label, $format, $text) = @_;

   local($oldfmt) = $GLSCURRENTFORMAT;

   if (defined($format))
   {
      $format=~s/[\(\)]//;

      if ($format)
      {
         $GLSCURRENTFORMAT=$format;
      }
   }

   $id = ++$global{'max_id'};

   local($str) = &make_real_glossary_entry($label,$text,$type);
   $GLSCURRENTFORMAT = $oldfmt;

   $str;
}

sub do_cmd_glsadd{
   local($_) = @_;
   local($optarg,$pat,$label,$str,$id,$type,$format);
   ($optarg,$pat) = &get_next_optional_argument;

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   $type = &gls_get_type($label);

   local($dobacklink) = 1;

   if (&gls_used($label))
   {
      if ($INDEXONLYFIRST)
      {
        $dobacklink = 0;
      }
   }
   else
   {
      &unset_entry($label);
   }

   if (defined $type)
   {
      ($format,$optarg) = &get_keyval('format', $optarg);
      $format='' unless(defined($format));

      if ($dobacklink)
      {
         &gls_add_entry($type,$label,$format,"");
      }
      else
      {
         $glsentry{$label}{'maxid'} = ++$glsentry{$entry}{'maxid'};
         my $key = $label."###".$glsentry{$label}{'maxid'};
         $glossary{$type}{$key}='';
      }
   }
   else
   {
      &write_warnings("gls_add: glossary entry '$label' undefined");
      $str = '';
   }

   $str . $_;
}

sub do_cmd_glsaddall{
   local($_) = @_;
   local($optarg,$pat) = &get_next_optional_argument;

   local($format,$list);

   ($list,$optarg) = &get_keyval('types', $optarg);
   ($format,$optarg) = &get_keyval('format', $optarg);

   $format='' unless(defined($format));

   local(@types) = keys(%gls_mark);

   if ($list)
   {
      @types = split /\s*,\s*/, $list;
   }

   foreach $type (@types)
   {
      # strip leading and trailing spaces
      $type=~s/^\s*([^\s]+)\s*$/\1/;

      foreach $label (@{$gls_entries{$type}})
      {
         local($dobacklink) = 1;

         if (&gls_used($label))
         {
            if ($INDEXONLYFIRST)
            {
              $dobacklink = 0;
            }
         }
         else
         {
            &unset_entry($label);
         }

         if ($dobacklink)
         {
            &gls_add_entry($type,$label,$format,"");
         }
      }
   }

   $_;
}

sub do_cmd_glsresetall{
   local($_) = @_;
   local($types,$pat) = &get_next_optional_argument;

   local(@types) = keys(%gls_mark);

   if (defined($types) and $types)
   {
      @types = split /,/, $types;
   }

   foreach $type (@types)
   {
      # strip leasing and trailing spaces
      $type=~s/^\s*([^\s]+)\s*$/\1/;

      foreach $label (@{$gls_entries{$type}})
      {
         &reset_entry($label);
      }
   }

   $_;
}

sub do_cmd_glsunsetall{
   local($_) = @_;
   local($types,$pat) = &get_next_optional_argument;

   local(@types) = keys(%gls_mark);

   if (defined($types) and $types)
   {
      @types = split /,/, $types;
   }

   foreach $type (@types)
   {
      # strip leasing and trailing spaces
      $type=~s/^\s*([^\s]+)\s*$/\1/;

      foreach $label (@{$gls_entries{$type}})
      {
         &reset_entry($label);
      }
   }

   $_;
}

$glslabel = '';

sub do_cmd_glslabel{ $glslabel.$_[0] }

sub make_glslink{
   local($type,$label,$format,$text) = @_;
   local($str) = '';

   $glslabel = $label;

   if (defined $type)
   {
      $str = &gls_add_entry($type,$label,$format,$text);
   }
   else
   {
      &write_warnings("glossary '$type' undefined");
   }

   $str;
}

sub do_cmd_glslink{
   local($_) = @_;
   local($optarg,$pat,$label,$text,$type,$format,$str);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   $text = &missing_braces unless
             (s/$next_pair_pr_rx/$text=$2;''/eo);

   # v1.01 removed following lines (\glslink doesn't have
   # a final optional argument!
   #local ($space) = '';
   #if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}
   #($optarg,$pat) = &get_next_optional_argument;

   $type = &gls_get_type($label);

   #&make_glslink($type, $label, $format, $text).$space . $_;
   &make_glslink($type, $label, $format, $text) . $_;
}

sub do_cmd_glslinkstar{
   local($_) = @_;
   local($optarg,$pat,$label,$text,$type,$format,$str);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   $text = &missing_braces unless
             (s/$next_pair_pr_rx/$text=$2;''/eo);

   $type = &gls_get_type($label);

   $text . $_;
}

sub do_cmd_glsdisp{
   local($_) = @_;
   local($optarg,$pat,$label,$text,$type,$format,$str);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   $text = &missing_braces unless
             (s/$next_pair_pr_rx/$text=$2;''/eo);

   local($dobacklink) = 1;

   if (&gls_used($label))
   {
      if ($INDEXONLYFIRST)
      {
        $dobacklink = 0;
      }
   }
   else
   {
      &unset_entry($label);
   }

   $type = &gls_get_type($label);

   if ($dobacklink)
   {
      &make_glslink($type, $label, $format, $text) .$space . $_;
   }
   else
   {
      &make_real_glossary_entry_no_backlink($label, $text, $type). $space . $_;
   }
}

sub do_cmd_glshyperlink{
   local($_) = @_;

   local($text,$pat) = &get_next_optional_argument;

   local($id, $label);

   $label = &missing_braces unless
      s/$next_pair_pr_rx/$id=$1,$label=$2;''/eo;

   $text = &gls_get_text($label) unless $text;

   local($type) = &gls_get_type($label);

   "<A HREF=\"$gls_file_mark{$type}#gls:$label\">$text<\/A>"
   .$_;
}

sub do_cmd_glsentrydesc{
   local($_) = @_;

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   &gls_get_description($label).$_;
}

sub do_cmd_Glsentrydesc{
   local($_) = @_;

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   &do_real_makefirstuc(&gls_get_description($label)).$_;
}

sub do_cmd_glsentrytext{
   local($_) = @_;

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   &gls_get_text($label).$_;
}

sub do_cmd_Glsentrytext{
   local($_) = @_;

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   &do_real_makefirstuc(&gls_get_text($label)).$_;
}

sub do_cmd_glsentryname{
   local($_) = @_;

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   &gls_get_name($label).$_;
}

sub do_cmd_Glsentryname{
   local($_) = @_;

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   &do_real_makefirstuc(&gls_get_name($label)).$_;
}

sub do_cmd_glsentryfirst{
   local($_) = @_;

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   &gls_get_first($label).$_;
}

sub do_cmd_Glsentryfirst{
   local($_) = @_;

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   &do_real_makefirstuc(&gls_get_first($label)).$_;
}

sub do_cmd_glsentryplural{
   local($_) = @_;

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   &gls_get_plural($label).$_;
}

sub do_cmd_Glsentryplural{
   local($_) = @_;

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   &do_real_makefirstuc(&gls_get_plural($label)).$_;
}

sub do_cmd_glsentryfirstplural{
   local($_) = @_;

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local($text)=$glsentry{$label}{'firstplural'};

   unless (defined($text))
   {
      &write_warnings("glossary entry '$label' has not been defined");
      $text = '';
   }

   "$text$_";
   &gls_get_firstplural($label).$_;
}

sub do_cmd_Glsentryfirstplural{
   local($_) = @_;

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   &do_real_makefirstuc(&gls_get_firstplural($label)).$_;
}

sub do_cmd_glsentrysymbol{
   local($_) = @_;

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   &gls_get_symbol($label).$_;
}

sub do_cmd_Glsentrysymbol{
   local($_) = @_;

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   &do_real_makefirstuc(&gls_get_symbol($label)).$_;
}

sub do_cmd_glsentryuseri{
   local($_) = @_;

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   &gls_get_user($label, 1).$_;
}

sub do_cmd_glsentryuserii{
   local($_) = @_;

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   &gls_get_user($label, 2).$_;
}

sub do_cmd_glsentryuseriii{
   local($_) = @_;

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   &gls_get_user($label, 3).$_;
}

sub do_cmd_glsentryuseriv{
   local($_) = @_;

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   &gls_get_user($label, 4).$_;
}

sub do_cmd_glsentryuserv{
   local($_) = @_;

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   &gls_get_user($label, 5).$_;
}

sub do_cmd_glsentryuservi{
   local($_) = @_;

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   &gls_get_user($label, 6).$_;
}

sub do_cmd_gls{
   local($_) = @_;
   local($optarg,$pat,$label,$text, $format, $insert);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local ($space) = '';
   if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}

   $insert = '';
   ($insert,$pat) = &get_next_optional_argument;

   local($display) = '';

   local($type) = &gls_get_type($label);

   local($dobacklink) = 1;

   if (&gls_used($label))
   {
      # entry has already been used

      $text = &gls_get_text($label);
      $display = &gls_get_display($type);

      if ($INDEXONLYFIRST)
      {
        $dobacklink = 0;
      }
   }
   else
   {
      # entry hasn't been used

      $text = &gls_get_first($label);
      $display = &gls_get_displayfirst($type);

      &unset_entry($label);
   }

   local($args) = '';

   local($id) = ++$global{'max_id'};
   $args .= "$OP$id$CP$text$OP$id$CP";

   $id = ++$global{'max_id'};
   $args .= "$OP$id$CP$glsentry{$label}{description}$OP$id$CP";

   $id = ++$global{'max_id'};
   $args .= "$OP$id$CP$glsentry{$label}{symbol}$OP$id$CP";

   $id = ++$global{'max_id'};
   $args .= "$OP$id$CP$insert$OP$id$CP";

   local($link_text) = &translate_commands("$display$args");

   if ($dobacklink)
   {
      &make_glslink($type, $label, $format, $link_text) .$space . $_;
   }
   else
   {
      &make_real_glossary_entry_no_backlink($label, $link_text, $type). $space . $_;
   }
}

# added v1.04
sub do_cmd_glsstar{
   local($_) = @_;
   local($optarg,$pat,$label,$text, $format, $insert);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local ($space) = '';
   if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}

   $insert = '';
   ($insert,$pat) = &get_next_optional_argument;

   local($display) = '';

   local($type) = &gls_get_type($label);

   if (&gls_used($label))
   {
      # entry has already been used

      $text = &gls_get_text($label);
      $display = &gls_get_display($type);
   }
   else
   {
      # entry hasn't been used

      $text = &gls_get_first($label);
      $display = &gls_get_displayfirst($type);

      &unset_entry($label);
   }

   local($args) = '';

   local($id) = ++$global{'max_id'};
   $args .= "$OP$id$CP$text$OP$id$CP";

   $id = ++$global{'max_id'};
   $args .= "$OP$id$CP$glsentry{$label}{description}$OP$id$CP";

   $id = ++$global{'max_id'};
   $args .= "$OP$id$CP$glsentry{$label}{symbol}$OP$id$CP";

   $id = ++$global{'max_id'};
   $args .= "$OP$id$CP$insert$OP$id$CP";

   local($link_text) = &translate_commands("$display$args");

   $link_text . $space . $_;
}

sub do_cmd_glspl{
   local($_) = @_;
   local($optarg,$pat,$label,$text, $format, $insert);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local ($space) = '';
   if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}

   $insert = '';
   ($insert,$pat) = &get_next_optional_argument;

   local($display) = '';

   local($type) = $glsentry{$label}{'type'};

   local($dobacklink) = 1;

   if (&gls_used($label))
   {
      # entry has already been used

      $text = &gls_get_plural($label);
      $display = &gls_get_display($type);;

      if ($INDEXONLYFIRST)
      {
        $dobacklink = 0;
      }
   }
   else
   {
      # entry hasn't been used

      $text = &gls_get_firstplural($label);
      $display = &gls_get_displayfirst($type);

      &unset_entry($label);
   }

   local($args) = '';

   local($id) = ++$global{'max_id'};
   $args .= "$OP$id$CP$text$OP$id$CP";

   $id = ++$global{'max_id'};
   $args .= "$OP$id$CP$glsentry{$label}{description}$OP$id$CP";

   $id = ++$global{'max_id'};
   $args .= "$OP$id$CP$glsentry{$label}{symbol}$OP$id$CP";

   $id = ++$global{'max_id'};
   $args .= "$OP$id$CP$insert$OP$id$CP";

   local($link_text) = &translate_commands("$display$args");

   if ($dobacklink)
   {
      &make_glslink($type, $label, $format, $link_text) .$space . $_;
   }
   else
   {
      &make_real_glossary_entry_no_backlink($label, $link_text, $type). $space . $_;
   }
}

# added v1.04
sub do_cmd_glsplstar{
   local($_) = @_;
   local($optarg,$pat,$label,$text, $format, $insert);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local ($space) = '';
   if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}

   $insert = '';
   ($insert,$pat) = &get_next_optional_argument;

   local($display) = '';

   local($type) = $glsentry{$label}{'type'};

   if (&gls_used($label))
   {
      # entry has already been used

      $text = &gls_get_plural($label);
      $display = &gls_get_display($type);;
   }
   else
   {
      # entry hasn't been used

      $text = &gls_get_firstplural($label);
      $display = &gls_get_displayfirst($type);

      &unset_entry($label);
   }

   local($args) = '';

   local($id) = ++$global{'max_id'};
   $args .= "$OP$id$CP$text$OP$id$CP";

   $id = ++$global{'max_id'};
   $args .= "$OP$id$CP$glsentry{$label}{description}$OP$id$CP";

   $id = ++$global{'max_id'};
   $args .= "$OP$id$CP$glsentry{$label}{symbol}$OP$id$CP";

   $id = ++$global{'max_id'};
   $args .= "$OP$id$CP$insert$OP$id$CP";

   local($link_text) = &translate_commands("$display$args");

   $link_text . $space . $_;
}

sub do_cmd_Gls{
   local($_) = @_;
   local($optarg,$pat,$label,$text, $format, $insert);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local ($space) = '';
   if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}

   $insert = '';
   ($insert,$pat) = &get_next_optional_argument;

   local($display) = '';

   local($type) = $glsentry{$label}{'type'};

   local($dobacklink) = 1;

   if (&gls_used($label))
   {
      # entry has already been used

      $text = &gls_get_text($label);
      $display = &gls_get_display($type);;

      if ($INDEXONLYFIRST)
      {
        $dobacklink = 0;
      }
   }
   else
   {
      # entry hasn't been used

      $text = &gls_get_first($label);
      $display = &gls_get_displayfirst($type);

      &unset_entry($label);
   }

   local($args) = '';

   local($id) = ++$global{'max_id'};
   $args .= "$OP$id$CP$text$OP$id$CP";

   $id = ++$global{'max_id'};
   $args .= "$OP$id$CP$glsentry{$label}{description}$OP$id$CP";

   $id = ++$global{'max_id'};
   $args .= "$OP$id$CP$glsentry{$label}{symbol}$OP$id$CP";

   $id = ++$global{'max_id'};
   $args .= "$OP$id$CP$insert$OP$id$CP";

   local($link_text) = &do_real_makefirstuc(&translate_commands("$display$args"));

   if ($dobacklink)
   {
      &make_glslink($type, $label, $format, $link_text) .$space . $_;
   }
   else
   {
      &make_real_glossary_entry_no_backlink($label, $link_text, $type). $space . $_;
   }
}

# added v1.04
sub do_cmd_Glsstar{
   local($_) = @_;
   local($optarg,$pat,$label,$text, $format, $insert);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local ($space) = '';
   if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}

   $insert = '';
   ($insert,$pat) = &get_next_optional_argument;

   local($display) = '';

   local($type) = $glsentry{$label}{'type'};

   if (&gls_used($label))
   {
      # entry has already been used

      $text = &gls_get_text($label);
      $display = &gls_get_display($type);;
   }
   else
   {
      # entry hasn't been used

      $text = &gls_get_first($label);
      $display = &gls_get_displayfirst($type);

      &unset_entry($label);
   }

   local($args) = '';

   local($id) = ++$global{'max_id'};
   $args .= "$OP$id$CP$text$OP$id$CP";

   $id = ++$global{'max_id'};
   $args .= "$OP$id$CP$glsentry{$label}{description}$OP$id$CP";

   $id = ++$global{'max_id'};
   $args .= "$OP$id$CP$glsentry{$label}{symbol}$OP$id$CP";

   $id = ++$global{'max_id'};
   $args .= "$OP$id$CP$insert$OP$id$CP";

   local($link_text) = &translate_commands("$display$args");

   &do_real_makefirstuc($link_text). $space . $_;
}

sub do_cmd_Glspl{
   local($_) = @_;
   local($optarg,$pat,$label,$text, $format, $insert);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local ($space) = '';
   if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}

   $insert = '';
   ($insert,$pat) = &get_next_optional_argument;

   local($display) = '';

   local($type) = $glsentry{$label}{'type'};

   local($dobacklink) = 1;

   if (&gls_used($label))
   {
      # entry has already been used

      $text = &gls_get_plural($label);
      $display = &gls_get_display($type);;

      if ($INDEXONLYFIRST)
      {
        $dobacklink = 0;
      }
   }
   else
   {
      # entry hasn't been used

      $text = &gls_get_firstplural($label);
      $display = &gls_get_displayfirst($type);

      &unset_entry($label);
   }

   local($args) = '';

   local($id) = ++$global{'max_id'};
   $args .= "$OP$id$CP$text$OP$id$CP";

   $id = ++$global{'max_id'};
   $args .= "$OP$id$CP$glsentry{$label}{description}$OP$id$CP";

   $id = ++$global{'max_id'};
   $args .= "$OP$id$CP$glsentry{$label}{symbol}$OP$id$CP";

   $id = ++$global{'max_id'};
   $args .= "$OP$id$CP$insert$OP$id$CP";

   local($link_text) = &do_real_makefirstuc(&translate_commands("$display$args"));

   if ($dobacklink)
   {
      &make_glslink($type, $label, $format, $link_text) .$space . $_;
   }
   else
   {
      &make_real_glossary_entry_no_backlink($label, $link_text, $type). $space . $_;
   }
}

# added v1.04
sub do_cmd_Glsplstar{
   local($_) = @_;
   local($optarg,$pat,$label,$text, $format, $insert);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local ($space) = '';
   if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}

   $insert = '';
   ($insert,$pat) = &get_next_optional_argument;

   local($display) = '';

   local($type) = $glsentry{$label}{'type'};

   if (&gls_used($label))
   {
      # entry has already been used

      $text = &gls_get_plural($label);
      $display = &gls_get_display($type);;
   }
   else
   {
      # entry hasn't been used

      $text = &gls_get_firstplural($label);
      $display = &gls_get_displayfirst($type);

      &unset_entry($label);
   }

   local($args) = '';

   local($id) = ++$global{'max_id'};
   $args .= "$OP$id$CP$text$OP$id$CP";

   $id = ++$global{'max_id'};
   $args .= "$OP$id$CP$glsentry{$label}{description}$OP$id$CP";

   $id = ++$global{'max_id'};
   $args .= "$OP$id$CP$glsentry{$label}{symbol}$OP$id$CP";

   $id = ++$global{'max_id'};
   $args .= "$OP$id$CP$insert$OP$id$CP";

   local($link_text) = &translate_commands("$display$args");

   &do_real_makefirstuc($link_text).$space . $_;
}

sub do_cmd_GLS{
   local($_) = @_;
   local($optarg,$pat,$label,$text, $format, $insert);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local ($space) = '';
   if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}

   $insert = '';
   ($insert,$pat) = &get_next_optional_argument;

   local($display) = '';

   local($type) = $glsentry{$label}{'type'};

   local($dobacklink) = 1;

   if (&gls_used($label))
   {
      # entry has already been used

      $text = &gls_get_text($label);
      $display = &gls_get_display($type);;

      if ($INDEXONLYFIRST)
      {
        $dobacklink = 0;
      }
   }
   else
   {
      # entry hasn't been used

      $text = &gls_get_first($label);
      $display = &gls_get_displayfirst($type);

      &unset_entry($label);
   }

   local($args) = '';

   local($id) = ++$global{'max_id'};
   $args .= "$OP$id$CP$text$OP$id$CP";

   $id = ++$global{'max_id'};
   $args .= "$OP$id$CP$glsentry{$label}{description}$OP$id$CP";

   $id = ++$global{'max_id'};
   $args .= "$OP$id$CP$glsentry{$label}{symbol}$OP$id$CP";

   $id = ++$global{'max_id'};
   $args .= "$OP$id$CP$insert$OP$id$CP";

   local($link_text) = uc(&translate_commands("$display$args"));

   if ($dobacklink)
   {
      &make_glslink($type, $label, $format, $link_text) .$space . $_;
   }
   else
   {
      &make_real_glossary_entry_no_backlink($label, $link_text, $type). $space . $_;
   }
}

# added v1.04
sub do_cmd_GLSstar{
   local($_) = @_;
   local($optarg,$pat,$label,$text, $format, $insert);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local ($space) = '';
   if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}

   $insert = '';
   ($insert,$pat) = &get_next_optional_argument;

   local($display) = '';

   local($type) = $glsentry{$label}{'type'};

   if (&gls_used($label))
   {
      # entry has already been used

      $text = &gls_get_text($label);
      $display = &gls_get_display($type);;
   }
   else
   {
      # entry hasn't been used

      $text = &gls_get_first($label);
      $display = &gls_get_displayfirst($type);

      &unset_entry($label);
   }

   local($args) = '';

   local($id) = ++$global{'max_id'};
   $args .= "$OP$id$CP$text$OP$id$CP";

   $id = ++$global{'max_id'};
   $args .= "$OP$id$CP$glsentry{$label}{description}$OP$id$CP";

   $id = ++$global{'max_id'};
   $args .= "$OP$id$CP$glsentry{$label}{symbol}$OP$id$CP";

   $id = ++$global{'max_id'};
   $args .= "$OP$id$CP$insert$OP$id$CP";

   local($link_text) = &translate_commands("$display$args");

   uc($link_text).$space . $_;
}

sub do_cmd_GLSpl{
   local($_) = @_;
   local($optarg,$pat,$label,$text, $format, $insert);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local ($space) = '';
   if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}

   $insert = '';
   ($insert,$pat) = &get_next_optional_argument;

   local($display) = '';

   local($type) = $glsentry{$label}{'type'};

   local($dobacklink) = 1;

   if (&gls_used($label))
   {
      # entry has already been used

      $text = &gls_get_plural($label);
      $display = &gls_get_display($type);;

      if ($INDEXONLYFIRST)
      {
        $dobacklink = 0;
      }
   }
   else
   {
      # entry hasn't been used

      $text = &gls_get_firstplural($label);
      $display = &gls_get_displayfirst($type);

      &unset_entry($label);
   }

   local($args) = '';

   local($id) = ++$global{'max_id'};
   $args .= "$OP$id$CP$text$OP$id$CP";

   $id = ++$global{'max_id'};
   $args .= "$OP$id$CP$glsentry{$label}{description}$OP$id$CP";

   $id = ++$global{'max_id'};
   $args .= "$OP$id$CP$glsentry{$label}{symbol}$OP$id$CP";

   $id = ++$global{'max_id'};
   $args .= "$OP$id$CP$insert$OP$id$CP";

   local($link_text) = uc(&translate_commands("$display$args"));

   if ($dobacklink)
   {
      &make_glslink($type, $label, $format, $link_text) .$space . $_;
   }
   else
   {
      &make_real_glossary_entry_no_backlink($label, $link_text, $type). $space . $_;
   }
}

# added v1.04
sub do_cmd_GLSplstar{
   local($_) = @_;
   local($optarg,$pat,$label,$text, $format, $insert);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local ($space) = '';
   if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}

   $insert = '';
   ($insert,$pat) = &get_next_optional_argument;

   local($display) = '';

   local($type) = $glsentry{$label}{'type'};

   if (&gls_used($label))
   {
      # entry has already been used

      $text = &gls_get_plural($label);
      $display = &gls_get_display($type);;
   }
   else
   {
      # entry hasn't been used

      $text = &gls_get_firstplural($label);
      $display = &gls_get_displayfirst($type);

      &unset_entry($label);
   }

   local($args) = '';

   local($id) = ++$global{'max_id'};
   $args .= "$OP$id$CP$text$OP$id$CP";

   $id = ++$global{'max_id'};
   $args .= "$OP$id$CP$glsentry{$label}{description}$OP$id$CP";

   $id = ++$global{'max_id'};
   $args .= "$OP$id$CP$glsentry{$label}{symbol}$OP$id$CP";

   $id = ++$global{'max_id'};
   $args .= "$OP$id$CP$insert$OP$id$CP";

   local($link_text) = &translate_commands("$display$args");

   uc($link_text).$space . $_;
}

# added 22 Feb 2008
sub do_cmd_glstext{
   local($_) = @_;
   local($optarg,$pat,$label,$text, $format, $insert);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local ($space) = '';
   if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}

   $insert = '';
   ($insert,$pat) = &get_next_optional_argument;

   local($display) = '';

   local($type) = &gls_get_type($label);

   $text = &gls_get_text($label);

   &make_glslink($type, $label, $format, $text) .$space . $_;
}

# added 22 Feb 2008
sub do_cmd_Glstext{
   local($_) = @_;
   local($optarg,$pat,$label,$text, $format, $insert);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local ($space) = '';
   if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}

   $insert = '';
   ($insert,$pat) = &get_next_optional_argument;

   local($display) = '';

   local($type) = &gls_get_type($label);

   $text = &gls_get_text($label);

   &make_glslink($type, $label, $format, &do_real_makefirstuc($text)) .$space . $_;
}

# added 22 Feb 2008
sub do_cmd_GLStext{
   local($_) = @_;
   local($optarg,$pat,$label,$text, $format, $insert);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local ($space) = '';
   if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}

   $insert = '';
   ($insert,$pat) = &get_next_optional_argument;

   local($display) = '';

   local($type) = &gls_get_type($label);

   $text = &gls_get_text($label);

   &make_glslink($type, $label, $format, uc($text)) .$space . $_;
}

# added 22 Feb 2008
sub do_cmd_glsname{
   local($_) = @_;
   local($optarg,$pat,$label,$text, $format, $insert);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local ($space) = '';
   if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}

   $insert = '';
   ($insert,$pat) = &get_next_optional_argument;

   local($display) = '';

   local($type) = &gls_get_type($label);

   $text = &gls_get_name($label);

   &make_glslink($type, $label, $format, $text) .$space . $_;
}

# added 22 Feb 2008
sub do_cmd_Glsname{
   local($_) = @_;
   local($optarg,$pat,$label,$text, $format, $insert);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local ($space) = '';
   if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}

   $insert = '';
   ($insert,$pat) = &get_next_optional_argument;

   local($display) = '';

   local($type) = &gls_get_type($label);

   $text = &gls_get_name($label);

   &make_glslink($type, $label, $format, &do_real_makefirstuc($text)) .$space . $_;
}

# added 22 Feb 2008
sub do_cmd_GLSname{
   local($_) = @_;
   local($optarg,$pat,$label,$text, $format, $insert);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local ($space) = '';
   if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}

   $insert = '';
   ($insert,$pat) = &get_next_optional_argument;

   local($display) = '';

   local($type) = &gls_get_type($label);

   $text = &gls_get_name($label);

   &make_glslink($type, $label, $format, uc($text)) .$space . $_;
}

# added 22 Feb 2008
sub do_cmd_glsfirst{
   local($_) = @_;
   local($optarg,$pat,$label,$text, $format, $insert);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local ($space) = '';
   if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}

   $insert = '';
   ($insert,$pat) = &get_next_optional_argument;

   local($display) = '';

   local($type) = &gls_get_type($label);

   $text = &gls_get_first($label);

   &make_glslink($type, $label, $format, $text) .$space . $_;
}

# added 22 Feb 2008
sub do_cmd_Glsfirst{
   local($_) = @_;
   local($optarg,$pat,$label,$text, $format, $insert);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local ($space) = '';
   if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}

   $insert = '';
   ($insert,$pat) = &get_next_optional_argument;

   local($display) = '';

   local($type) = &gls_get_type($label);

   $text = &gls_get_first($label);

   &make_glslink($type, $label, $format, &do_real_makefirstuc($text)) .$space . $_;
}

# added 22 Feb 2008
sub do_cmd_GLSfirst{
   local($_) = @_;
   local($optarg,$pat,$label,$text, $format, $insert);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local ($space) = '';
   if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}

   $insert = '';
   ($insert,$pat) = &get_next_optional_argument;

   local($display) = '';

   local($type) = &gls_get_type($label);

   $text = &gls_get_first($label);

   &make_glslink($type, $label, $format, uc($text)) .$space . $_;
}

# added 22 Feb 2008
sub do_cmd_glsfirstplural{
   local($_) = @_;
   local($optarg,$pat,$label,$text, $format, $insert);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local ($space) = '';
   if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}

   $insert = '';
   ($insert,$pat) = &get_next_optional_argument;

   local($display) = '';

   local($type) = &gls_get_type($label);

   $text = &gls_get_firstplural($label);

   &make_glslink($type, $label, $format, $text) .$space . $_;
}

# added 22 Feb 2008
sub do_cmd_Glsfirstplural{
   local($_) = @_;
   local($optarg,$pat,$label,$text, $format, $insert);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local ($space) = '';
   if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}

   $insert = '';
   ($insert,$pat) = &get_next_optional_argument;

   local($display) = '';

   local($type) = &gls_get_type($label);

   $text = &gls_get_firstplural($label);

   &make_glslink($type, $label, $format, &do_real_makefirstuc($text)) .$space . $_;
}

# added 22 Feb 2008
sub do_cmd_GLSfirstplural{
   local($_) = @_;
   local($optarg,$pat,$label,$text, $format, $insert);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local ($space) = '';
   if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}

   $insert = '';
   ($insert,$pat) = &get_next_optional_argument;

   local($display) = '';

   local($type) = &gls_get_type($label);

   $text = &gls_get_firstplural($label);

   &make_glslink($type, $label, $format, uc($text)) .$space . $_;
}

# added 22 Feb 2008
sub do_cmd_glsplural{
   local($_) = @_;
   local($optarg,$pat,$label,$text, $format, $insert);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local ($space) = '';
   if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}

   $insert = '';
   ($insert,$pat) = &get_next_optional_argument;

   local($display) = '';

   local($type) = &gls_get_type($label);

   $text = &gls_get_plural($label);

   &make_glslink($type, $label, $format, $text) .$space . $_;
}

# added 22 Feb 2008
sub do_cmd_Glsplural{
   local($_) = @_;
   local($optarg,$pat,$label,$text, $format, $insert);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local ($space) = '';
   if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}

   $insert = '';
   ($insert,$pat) = &get_next_optional_argument;

   local($display) = '';

   local($type) = &gls_get_type($label);

   $text = &gls_get_plural($label);

   &make_glslink($type, $label, $format, &do_real_makefirstuc($text)) .$space . $_;
}

# added 22 Feb 2008
sub do_cmd_GLSplural{
   local($_) = @_;
   local($optarg,$pat,$label,$text, $format, $insert);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local ($space) = '';
   if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}

   $insert = '';
   ($insert,$pat) = &get_next_optional_argument;

   local($display) = '';

   local($type) = &gls_get_type($label);

   $text = &gls_get_plural($label);

   &make_glslink($type, $label, $format, uc($text)) .$space . $_;
}

# added 22 Feb 2008
sub do_cmd_glsdesc{
   local($_) = @_;
   local($optarg,$pat,$label,$text, $format, $insert);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local ($space) = '';
   if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}

   $insert = '';
   ($insert,$pat) = &get_next_optional_argument;

   local($display) = '';

   local($type) = &gls_get_type($label);

   $text = &gls_get_description($label);

   &make_glslink($type, $label, $format, $text) .$space . $_;
}

# added 22 Feb 2008
sub do_cmd_Glsdesc{
   local($_) = @_;
   local($optarg,$pat,$label,$text, $format, $insert);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local ($space) = '';
   if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}

   $insert = '';
   ($insert,$pat) = &get_next_optional_argument;

   local($display) = '';

   local($type) = &gls_get_type($label);

   $text = &gls_get_description($label);

   &make_glslink($type, $label, $format, &do_real_makefirstuc($text)) .$space . $_;
}

# added 22 Feb 2008
sub do_cmd_GLSdesc{
   local($_) = @_;
   local($optarg,$pat,$label,$text, $format, $insert);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local ($space) = '';
   if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}

   $insert = '';
   ($insert,$pat) = &get_next_optional_argument;

   local($display) = '';

   local($type) = &gls_get_type($label);

   $text = &gls_get_description($label);

   &make_glslink($type, $label, $format, uc($text)) .$space . $_;
}

# added 22 Feb 2008
sub do_cmd_glssymbol{
   local($_) = @_;
   local($optarg,$pat,$label,$text, $format, $insert);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local ($space) = '';
   if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}

   $insert = '';
   ($insert,$pat) = &get_next_optional_argument;

   local($display) = '';

   local($type) = &gls_get_type($label);

   $text = &gls_get_symbol($label);

   &make_glslink($type, $label, $format, $text) .$space . $_;
}

# added 22 Feb 2008
sub do_cmd_Glssymbol{
   local($_) = @_;
   local($optarg,$pat,$label,$text, $format, $insert);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local ($space) = '';
   if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}

   $insert = '';
   ($insert,$pat) = &get_next_optional_argument;

   local($display) = '';

   local($type) = &gls_get_type($label);

   $text = &gls_get_symbol($label);

   &make_glslink($type, $label, $format, &do_real_makefirstuc($text)) .$space . $_;
}

# added 22 Feb 2008
sub do_cmd_GLSsymbol{
   local($_) = @_;
   local($optarg,$pat,$label,$text, $format, $insert);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local ($space) = '';
   if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}

   $insert = '';
   ($insert,$pat) = &get_next_optional_argument;

   local($display) = '';

   local($type) = &gls_get_type($label);

   $text = &gls_get_symbol($label);

   &make_glslink($type, $label, $format, uc($text)) .$space . $_;
}

sub do_cmd_glsuseri{
   local($_) = @_;
   local($optarg,$pat,$label,$text, $format, $insert);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local ($space) = '';
   if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}

   $insert = '';
   ($insert,$pat) = &get_next_optional_argument;

   local($display) = '';

   local($type) = &gls_get_type($label);

   $text = &gls_get_user($label, 1);

   &make_glslink($type, $label, $format, $text) .$space . $_;
}

sub do_cmd_Glsuseri{
   local($_) = @_;
   local($optarg,$pat,$label,$text, $format, $insert);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local ($space) = '';
   if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}

   $insert = '';
   ($insert,$pat) = &get_next_optional_argument;

   local($display) = '';

   local($type) = &gls_get_type($label);

   $text = &do_real_makefirstuc(&gls_get_user($label, 1));

   &make_glslink($type, $label, $format, $text) .$space . $_;
}

sub do_cmd_glsuserii{
   local($_) = @_;
   local($optarg,$pat,$label,$text, $format, $insert);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local ($space) = '';
   if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}

   $insert = '';
   ($insert,$pat) = &get_next_optional_argument;

   local($display) = '';

   local($type) = &gls_get_type($label);

   $text = &gls_get_user($label, 2);

   &make_glslink($type, $label, $format, $text) .$space . $_;
}

sub do_cmd_Glsuserii{
   local($_) = @_;
   local($optarg,$pat,$label,$text, $format, $insert);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local ($space) = '';
   if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}

   $insert = '';
   ($insert,$pat) = &get_next_optional_argument;

   local($display) = '';

   local($type) = &gls_get_type($label);

   $text = &do_real_makefirstuc(&gls_get_user($label, 2));

   &make_glslink($type, $label, $format, $text) .$space . $_;
}

sub do_cmd_glsuseriii{
   local($_) = @_;
   local($optarg,$pat,$label,$text, $format, $insert);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local ($space) = '';
   if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}

   $insert = '';
   ($insert,$pat) = &get_next_optional_argument;

   local($display) = '';

   local($type) = &gls_get_type($label);

   $text = &gls_get_user($label, 3);

   &make_glslink($type, $label, $format, $text) .$space . $_;
}

sub do_cmd_Glsuseriii{
   local($_) = @_;
   local($optarg,$pat,$label,$text, $format, $insert);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local ($space) = '';
   if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}

   $insert = '';
   ($insert,$pat) = &get_next_optional_argument;

   local($display) = '';

   local($type) = &gls_get_type($label);

   $text = &do_real_makefirstuc(&gls_get_user($label, 3));

   &make_glslink($type, $label, $format, $text) .$space . $_;
}

sub do_cmd_glsuseriv{
   local($_) = @_;
   local($optarg,$pat,$label,$text, $format, $insert);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local ($space) = '';
   if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}

   $insert = '';
   ($insert,$pat) = &get_next_optional_argument;

   local($display) = '';

   local($type) = &gls_get_type($label);

   $text = &gls_get_user($label, 4);

   &make_glslink($type, $label, $format, $text) .$space . $_;
}

sub do_cmd_Glsuseriv{
   local($_) = @_;
   local($optarg,$pat,$label,$text, $format, $insert);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local ($space) = '';
   if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}

   $insert = '';
   ($insert,$pat) = &get_next_optional_argument;

   local($display) = '';

   local($type) = &gls_get_type($label);

   $text = &do_real_makefirstuc(&gls_get_user($label, 4));

   &make_glslink($type, $label, $format, $text) .$space . $_;
}

sub do_cmd_glsuserv{
   local($_) = @_;
   local($optarg,$pat,$label,$text, $format, $insert);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local ($space) = '';
   if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}

   $insert = '';
   ($insert,$pat) = &get_next_optional_argument;

   local($display) = '';

   local($type) = &gls_get_type($label);

   $text = &gls_get_user($label, 5);

   &make_glslink($type, $label, $format, $text) .$space . $_;
}

sub do_cmd_Glsuserv{
   local($_) = @_;
   local($optarg,$pat,$label,$text, $format, $insert);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local ($space) = '';
   if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}

   $insert = '';
   ($insert,$pat) = &get_next_optional_argument;

   local($display) = '';

   local($type) = &gls_get_type($label);

   $text = &do_real_makefirstuc(&gls_get_user($label, 5));

   &make_glslink($type, $label, $format, $text) .$space . $_;
}

sub do_cmd_glsuservi{
   local($_) = @_;
   local($optarg,$pat,$label,$text, $format, $insert);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local ($space) = '';
   if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}

   $insert = '';
   ($insert,$pat) = &get_next_optional_argument;

   local($display) = '';

   local($type) = &gls_get_type($label);

   $text = &gls_get_user($label, 6);

   &make_glslink($type, $label, $format, $text) .$space . $_;
}

sub do_cmd_Glsuservi{
   local($_) = @_;
   local($optarg,$pat,$label,$text, $format, $insert);

   ($optarg,$pat) = &get_next_optional_argument;

   ($format,$optarg) = &get_keyval('format', $optarg);

   $label = &missing_braces unless
             (s/$next_pair_pr_rx/$label=$2;''/eo);

   local ($space) = '';
   if (/^\s+[^\[]/ or /^\s*\[.*\]\s/) {$space = ' ';}

   $insert = '';
   ($insert,$pat) = &get_next_optional_argument;

   local($display) = '';

   local($type) = &gls_get_type($label);

   $text = &do_real_makefirstuc(&gls_get_user($label, 6));

   &make_glslink($type, $label, $format, $text) .$space . $_;
}

sub do_cmd_acrshort{
  &do_cmd_glstext(@_)
}

sub do_cmd_Acrshort{
  &do_cmd_Glstext(@_)
}

sub do_cmd_ACRshort{
  &do_cmd_GLStext(@_)
}

sub do_cmd_acrlong{
  &do_cmd_glsdesc(@_)
}

sub do_cmd_Acrlong{
  &do_cmd_Glsdesc(@_)
}

sub do_cmd_ACRlong{
  &do_cmd_GLSdesc(@_)
}

sub do_cmd_acrfull{
  &do_cmd_glsfirst(@_)
}

sub do_cmd_Acrfull{
  &do_cmd_Glsfirst(@_)
}

sub do_cmd_ACRfull{
  &do_cmd_GLSfirst(@_)
}

sub do_cmd_glossarypreamble{
   local($_) = @_;
   $_[0];
}

sub do_cmd_glossarypostamble{
   local($_) = @_;
   $_[0];
}

sub do_cmd_glsnumformat{
   local($_) = @_;

   $_;
}

sub do_cmd_hyperit{
   join('', "\\textit ", $_[0]);
}

sub do_cmd_hyperrm{
   join('', "\\textrm ", $_[0]);
}

sub do_cmd_hypertt{
   join('', "\\texttt ", $_[0]);
}

sub do_cmd_hypersf{
   join('', "\\textsf ", $_[0]);
}

sub do_cmd_hyperbf{
   join('', "\\textbf ", $_[0]);
}

&ignore_commands( <<_IGNORED_CMDS_ );
makeglossary
makeglossaries
glossaryentrynumbers # {}
_IGNORED_CMDS_

1;
