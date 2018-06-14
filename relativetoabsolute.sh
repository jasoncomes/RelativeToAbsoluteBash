for file in **/*.html; do

    # Use Frontmatter Permalink Variable as Permalink
    permalink=$(perl -l -0777 -ne 'print $1 if /permalink: \/(.*?)\/?\n/si' $file);

    # Use Folder Structure as Permalink
    # permalink=$(echo $file | sed 's/\.html//g');

    # Skip Empty Permalink
    if [ -z "$permalink" ]; then
        continue;
    fi;

    # Permalink into Array
    IFS='/' read -r -a array <<< "$permalink";

    # http="/" to http="{{ site.url }}"
    perl -pi -w -e "s/href=(\"|\')\/?(\"|\')/href=\$1\{\{ site.url \}\}\$2/g;" $file;

    # http="/slug" to http="{{ site.url }}/slug"
    perl -pi -w -e "s/href=(\"|\')\/([a-zA-Z0-9\/_-]+)\/?(\"|\')/href=\$1\{\{ site.url \}\}\/\$2\$3/g;" $file;

     # Setup URLs
    case ${#array[@]} in
    1) # 1 Page Slug
        perl -pi -w -e "s/href=(\"|\')(?!(http|www|\{\{))([a-zA-Z0-9\/_-]+)\/?(\"|\')/href=\$1\{\{ site.url \}\}\/\$3\$4/g;" $file; # http="slug" to {{ site.url }}/slug
    ;;
    2) # 1 Category + 1 Page Slug
        perl -pi -w -e "s/href=(\"|\')(?!(http|www|\{\{))\.\.\/(\"|\')/href=\$1\{\{ site.url \}\}\/\$3/g;" $file; # http="../" to http="{{ site.url }}/"
        perl -pi -w -e "s/href=(\"|\')(?!(http|www|\{\{))([a-zA-Z0-9\/_-]+)\/?(\"|\')/href=\$1\{\{ site.url \}\}\/${array[0]}\/\$3\$4/g;" $file; # http="slug" to http="{{ site.url }}/first/slug"
    ;;
    3) # 2 Categories + 1 Page Slug
        perl -pi -w -e "s/href=(\"|\')(?!(http|www|\{\{))\.\.\/([a-zA-Z0-9\/_-]+)\/?(\"|\')/href=\$1\{\{ site.url \}\}\/${array[0]}\/\$3\$4/g;" $file; # http="../slug" to http="{{ site.url }}/first/slug"
        perl -pi -w -e "s/href=(\"|\')(?!(http|www|\{\{))\.\.\/(\"|\')/href=\$1\{\{ site.url \}\}\/${array[0]}\/\$3/g;" $file; # http="../" to http="{{ site.url }}/first"
        perl -pi -w -e "s/href=(\"|\')(?!(http|www|\{\{))([a-zA-Z0-9\/_-]+)\/?(\"|\')/href=\$1\{\{ site.url \}\}\/${array[0]}\/${array[1]}\/\$3\$4/g;" $file; # http="slug" to {{ site.url }}/first/second/slug
    ;;
    4) # 3 Categories + 1 Page Slug
        perl -pi -w -e "s/href=(\"|\')(?!(http|www|\{\{))\.\.\/\.\.\/([a-zA-Z0-9\/_-]+)\/?(\"|\')/href=\$1\{\{ site.url \}\}\/${array[0]}\/\$3\$4/g;" $file; # http="../../slug" to http="{{ site.url }}/first/slug"
        perl -pi -w -e "s/href=(\"|\')(?!(http|www|\{\{))\.\.\/\.\.\/(\"|\')/href=\$1\{\{ site.url \}\}\/${array[0]}\/\$3/g;" $file; # http="../../" to http="{{ site.url }}/first"
        perl -pi -w -e "s/href=(\"|\')(?!(http|www|\{\{))\.\.\/([a-zA-Z0-9\/_-]+)\/?(\"|\')/href=\$1\{\{ site.url \}\}\/${array[0]}\/${array[1]}\/\$3\$4/g;" $file; # http="../slug" to http="{{ site.url }}/first/second/slug"
        perl -pi -w -e "s/href=(\"|\')(?!(http|www|\{\{))\.\.\/(\"|\')/href=\$1\{\{ site.url \}\}\/${array[0]}\/${array[1]}\/\$3/g;" $file; # http="../" to http="{{ site.url }}/first/second"
        perl -pi -w -e "s/href=(\"|\')(?!(http|www|\{\{))([a-zA-Z0-9\/_-]+)\/?(\"|\')/href=\$1\{\{ site.url \}\}\/${array[0]}\/${array[1]}\/${array[2]}\/\$3\$4/g;" $file; # http="slug" to {{ site.url }}/first/second/third/slug
    ;;
    5) # 4 Categories + 1 Page Slug
        perl -pi -w -e "s/href=(\"|\')(?!(http|www|\{\{))\.\.\/\.\.\/\.\.\/([a-zA-Z0-9\/_-]+)\/?(\"|\')/href=\$1\{\{ site.url \}\}\/${array[0]}\/\$3\$4/g;" $file; # http="../../../slug" to http="{{ site.url }}/first/slug"
        perl -pi -w -e "s/href=(\"|\')(?!(http|www|\{\{))\.\.\/\.\.\/\.\.\/(\"|\')/href=\$1\{\{ site.url \}\}\/${array[0]}\/\$3/g;" $file; # http="../../../" to http="{{ site.url }}/first"
        perl -pi -w -e "s/href=(\"|\')(?!(http|www|\{\{))\.\.\/\.\.\/([a-zA-Z0-9\/_-]+)\/?(\"|\')/href=\$1\{\{ site.url \}\}\/${array[0]}\/${array[1]}\/\$3\$4/g;" $file; # http="../../slug" to http="{{ site.url }}/first/second/slug"
        perl -pi -w -e "s/href=(\"|\')(?!(http|www|\{\{))\.\.\/\.\.\/(\"|\')/href=\$1\{\{ site.url \}\}\/${array[0]}\/${array[1]}\/\$3/g;" $file; # http="../../" to http="{{ site.url }}/first/second"
        perl -pi -w -e "s/href=(\"|\')(?!(http|www|\{\{))\.\.\/([a-zA-Z0-9\/_-]+)\/?(\"|\')/href=\$1\{\{ site.url \}\}\/${array[0]}\/${array[1]}\/${array[2]}\/\$3\$4/g;" $file; # http="../slug" to http="{{ site.url }}/first/second/third/slug"
        perl -pi -w -e "s/href=(\"|\')(?!(http|www|\{\{))\.\.\/(\"|\')/href=\$1\{\{ site.url \}\}\/${array[0]}\/${array[1]}\/${array[2]}\/\$3/g;" $file; # http="../" to http="{{ site.url }}/first/second/third"
        perl -pi -w -e "s/href=(\"|\')(?!(http|www|\{\{))([a-zA-Z0-9\/_-]+)\/?(\"|\')/href=\$1\{\{ site.url \}\}\/${array[0]}\/${array[1]}\/${array[2]}\/${array[3]}\/\$3\$4/g;" $file; # http="slug" to {{ site.url }}/first/second/third/fourth/slug
    ;;
    *)
        echo 'Boom!'
    ;;
    esac

    # http="(../|../../|../../../)slug" to http="{{ site.url }}/slug"
    perl -pi -w -e "s/href=(\"|\')(?!(http|www|\{\{)).*\.\/([a-zA-Z0-9\/_-]+)\/?(\"|\')/href=\$1\{\{ site.url \}\}\/\$3\$4/g;" $file;

done;
