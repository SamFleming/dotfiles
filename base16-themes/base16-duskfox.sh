
Deprecated: Symfony\Component\Yaml\Parser::getNextEmbedBlock(): Implicitly marking parameter $indentation as nullable is deprecated, the explicit nullable type must be used instead in /Users/sam/.config/base16-builder-php/vendor/symfony/yaml/Parser.php on line 563

Deprecated: Symfony\Component\Yaml\Parser::preg_match(): Implicitly marking parameter $matches as nullable is deprecated, the explicit nullable type must be used instead in /Users/sam/.config/base16-builder-php/vendor/symfony/yaml/Parser.php on line 1043

Deprecated: Symfony\Component\Yaml\Inline::initialize(): Implicitly marking parameter $parsedLineNumber as nullable is deprecated, the explicit nullable type must be used instead in /Users/sam/.config/base16-builder-php/vendor/symfony/yaml/Inline.php on line 37

Deprecated: Symfony\Component\Yaml\Inline::initialize(): Implicitly marking parameter $parsedFilename as nullable is deprecated, the explicit nullable type must be used instead in /Users/sam/.config/base16-builder-php/vendor/symfony/yaml/Inline.php on line 37

Deprecated: Symfony\Component\Yaml\Inline::parse(): Implicitly marking parameter $value as nullable is deprecated, the explicit nullable type must be used instead in /Users/sam/.config/base16-builder-php/vendor/symfony/yaml/Inline.php on line 58

Deprecated: Symfony\Component\Yaml\Inline::parseScalar(): Implicitly marking parameter $delimiters as nullable is deprecated, the explicit nullable type must be used instead in /Users/sam/.config/base16-builder-php/vendor/symfony/yaml/Inline.php on line 258

Deprecated: Symfony\Component\Yaml\Inline::parseScalar(): Implicitly marking parameter $isQuoted as nullable is deprecated, the explicit nullable type must be used instead in /Users/sam/.config/base16-builder-php/vendor/symfony/yaml/Inline.php on line 258

Deprecated: Symfony\Component\Yaml\Inline::evaluateScalar(): Implicitly marking parameter $isQuotedString as nullable is deprecated, the explicit nullable type must be used instead in /Users/sam/.config/base16-builder-php/vendor/symfony/yaml/Inline.php on line 547

Deprecated: Mustache_Engine::loadSource(): Implicitly marking parameter $cache as nullable is deprecated, the explicit nullable type must be used instead in /Users/sam/.config/base16-builder-php/vendor/mustache/mustache/src/Mustache/Engine.php on line 727

Deprecated: Mustache_Parser::buildTree(): Implicitly marking parameter $parent as nullable is deprecated, the explicit nullable type must be used instead in /Users/sam/.config/base16-builder-php/vendor/mustache/mustache/src/Mustache/Parser.php on line 73
#!/bin/sh
# base16-shell (https://github.com/chriskempson/base16-shell)
# Base16 Shell template by Chris Kempson (http://chriskempson.com)
# duskfox scheme by EdenEast
export BASE16_THEME=duskfox

color00="23/21/36" # Base 00 - Black
color01="eb/6f/92" # Base 08 - Red
color02="a3/be/8c" # Base 0B - Green
color03="f6/c1/77" # Base 0A - Yellow
color04="56/9f/ba" # Base 0D - Blue
color05="c4/a7/e7" # Base 0E - Magenta
color06="9c/cf/d8" # Base 0C - Cyan
color07="e0/de/f4" # Base 05 - White
color08="47/40/7d" # Base 03 - Bright Black
color09=$color01 # Base 08 - Bright Red
color10=$color02 # Base 0B - Bright Green
color11=$color03 # Base 0A - Bright Yellow
color12=$color04 # Base 0D - Bright Blue
color13=$color05 # Base 0E - Bright Magenta
color14=$color06 # Base 0C - Bright Cyan
color15="e2/e0/f7" # Base 07 - Bright White
color16="ea/9a/97" # Base 09
color17="eb/98/c3" # Base 0F
color18="2d/2a/45" # Base 01
color19="37/33/54" # Base 02
color20="6e/6a/86" # Base 04
color21="cd/cb/e0" # Base 06
color_foreground="e0/de/f4" # Base 05
color_background="23/21/36" # Base 00

if [ -n "$TMUX" ]; then
  # Tell tmux to pass the escape sequences through
  # (Source: http://permalink.gmane.org/gmane.comp.terminal-emulators.tmux.user/1324)
  put_template() { printf '\033Ptmux;\033\033]4;%d;rgb:%s\033\033\\\033\\' $@; }
  put_template_var() { printf '\033Ptmux;\033\033]%d;rgb:%s\033\033\\\033\\' $@; }
  put_template_custom() { printf '\033Ptmux;\033\033]%s%s\033\033\\\033\\' $@; }
elif [ "${TERM%%[-.]*}" = "screen" ]; then
  # GNU screen (screen, screen-256color, screen-256color-bce)
  put_template() { printf '\033P\033]4;%d;rgb:%s\007\033\\' $@; }
  put_template_var() { printf '\033P\033]%d;rgb:%s\007\033\\' $@; }
  put_template_custom() { printf '\033P\033]%s%s\007\033\\' $@; }
elif [ "${TERM%%-*}" = "linux" ]; then
  put_template() { [ $1 -lt 16 ] && printf "\e]P%x%s" $1 $(echo $2 | sed 's/\///g'); }
  put_template_var() { true; }
  put_template_custom() { true; }
else
  put_template() { printf '\033]4;%d;rgb:%s\033\\' $@; }
  put_template_var() { printf '\033]%d;rgb:%s\033\\' $@; }
  put_template_custom() { printf '\033]%s%s\033\\' $@; }
fi

# 16 color space
put_template 0  $color00
put_template 1  $color01
put_template 2  $color02
put_template 3  $color03
put_template 4  $color04
put_template 5  $color05
put_template 6  $color06
put_template 7  $color07
put_template 8  $color08
put_template 9  $color09
put_template 10 $color10
put_template 11 $color11
put_template 12 $color12
put_template 13 $color13
put_template 14 $color14
put_template 15 $color15

# 256 color space
put_template 16 $color16
put_template 17 $color17
put_template 18 $color18
put_template 19 $color19
put_template 20 $color20
put_template 21 $color21

# foreground / background / cursor color
if [ -n "$ITERM_SESSION_ID" ]; then
  # iTerm2 proprietary escape codes
  put_template_custom Pg e0def4 # foreground
  put_template_custom Ph 232136 # background
  put_template_custom Pi e0def4 # bold color
  put_template_custom Pj 373354 # selection color
  put_template_custom Pk e0def4 # selected text color
  put_template_custom Pl e0def4 # cursor
  put_template_custom Pm 232136 # cursor text
else
  put_template_var 10 $color_foreground
  if [ "$BASE16_SHELL_SET_BACKGROUND" != false ]; then
    put_template_var 11 $color_background
    if [ "${TERM%%-*}" = "rxvt" ]; then
      put_template_var 708 $color_background # internal border (rxvt)
    fi
  fi
  put_template_custom 12 ";7" # cursor (reverse video)
fi

# clean up
unset -f put_template
unset -f put_template_var
unset -f put_template_custom
unset color00
unset color01
unset color02
unset color03
unset color04
unset color05
unset color06
unset color07
unset color08
unset color09
unset color10
unset color11
unset color12
unset color13
unset color14
unset color15
unset color16
unset color17
unset color18
unset color19
unset color20
unset color21
unset color_foreground
unset color_background
