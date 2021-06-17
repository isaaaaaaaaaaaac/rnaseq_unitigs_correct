#!/bin/bash

# directory of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

k=31
t=8
python="python3"
output="$SCRIPT_DIR/script_output"

while test $# -gt 0; do
    case "$1" in
    -in)
        shift
        if test $# -gt 0; then
            echo "From file $1"
            in=$1
        else
            echo "No input file provided (-in)"
            exit 1
        fi
        shift
        ;;
    -minia)
        shift
        if test $# -gt 0; then
            echo "Using minia path: $1"
            minia=$1
        else
            echo "No path for minia provided (-minia)"
            exit 1
        fi
        shift
        ;;
    -kat)
        shift
        if test $# -gt 0; then
            echo "Using kat path: $1"
            kat=$1
        else
            echo "No path for kat provided (-kat)"
            exit 1
        fi
        shift
        ;;
    -python)
        shift
        if test $# -gt 0; then
            echo "Using python path: $1"
            python=$1
        else
            echo "No path for python provided (-python)"
            exit 1
        fi
        shift
        ;;
    -output)
        shift
        if test $# -gt 0; then
            echo "Output directory: $1"
            output=$1
        else
            echo "No output directory provided (-output)"
            exit 1
        fi
        shift
        ;;
    -t)
        shift
        if test $# -gt 0; then
            t=$1
        else
            echo "No value provided for t (-t)"
            exit 1
        fi
        shift
        ;;
    -k)
        shift
        if test $# -gt 0; then
            k=$1
        else
            echo "No value provided for k (-k)"
            exit 1
        fi
        shift
        ;;
    *)
        break
        ;;
    esac
done

if [ -z ${in+x} ] || [ -z ${minia+x} ] || [ -z ${kat+x} ]; then
    echo
    echo "====================================================="
    echo "INVALID ARGUMENTS. -in, -minia AND -kat ARE MANDATORY"
    echo "====================================================="
    echo
    exit 1
fi

if ! test -f "$minia/build/bin/minia"; then
    echo "$minia/build/bin/minia does not exist."
    exit 1
fi
if ! test -f "$kat"; then
    echo "$kat does not exist."
    exit 1
fi

compressed_higher_length=0
if [ "${in##*.}" == "gz" ]; then
    compressed_higher_length=3
    unitigs=${in::-3}

    gunzip -f -k $in

    if test $? -ne 0; then
    echo "gunzip failed."
        exit 1
    fi

    echo
    echo "==========="
    echo "GUNZIP DONE"
    echo "==========="
    echo
else
    unitigs=${in}
fi


in_basename=$(basename $in)
gfa_unitigs="${in_basename::-11-$compressed_higher_length}.gfa"
contigs="${in_basename::-11-$compressed_higher_length}.contigs.fa"
gfa_contigs="${in_basename::-11-$compressed_higher_length}.contigs.gfa"

if ! test -f "$output"; then
    mkdir $output
fi

echo
echo "===================================="
echo "EXECUTABLES & OUTPUT DIRECTORY EXIST"
echo "===================================="
echo



# converts unitigs fasta format to unitigs graph
$python $minia/scripts/convertToGFA.py $unitigs $gfa_unitigs $k

if test $? -ne 0; then
echo "GFA conversion failed."
    exit 1
fi

echo
echo "========================="
echo "MINIA GFA CONVERSION DONE"
echo "========================="
echo



# remove tips from unitigs
$minia/build/bin/minia -in $gfa_unitigs -kmer-size $k -keep-isolated -no-bulge-removal -no-ec-removal

if test $? -ne 0; then
echo "unitigs tips removal failed."
    exit 1
fi

echo
echo "==============================="
echo "MINIA UNITIGS TIPS REMOVAL DONE"
echo "==============================="
echo



# convert resulting contigs to GFA, for visualization purposes
$python $minia/scripts/convertToGFA.py $contigs $gfa_contigs $k

if test $? -ne 0; then
echo "contigs GFA conversion failed."
    exit 1
fi

echo
echo "================================="
echo "MINIA CONTIGS GFA CONVERSION DONE"
echo "================================="
echo



$kat comp -t $t -n -m $k -o "$output/${in_basename::-14}" $unitigs $contigs

echo
echo "============="
echo "KAT COMP DONE"
echo "============="
echo



$python "$SCRIPT_DIR/print_kmer_data.py" "$output/${in_basename::-14}.stats"