def print_kmer_data(fname):
    with open(fname, 'r') as f:
        lines = f.readlines()
    hash_1 = lines[1].split()[-1].replace('"', '')
    hash_2 = lines[2].split()[-1].replace('"', '')

    total_kmers_1 = int(lines[5].split()[-1])
    total_kmers_2 = int(lines[6].split()[-1])

    kmers_only_in_1 = int(lines[9].split()[-1])
    kmers_only_in_2 = int(lines[10].split()[-1])

    print('Total K-mers in:')
    print(f' - {hash_1}: {total_kmers_1}')
    print(f' - {hash_2}: {total_kmers_2}')
    print()

    print(f'K-mers in {hash_1} but not in {hash_2}:')
    print(f' - {kmers_only_in_1}')
    print()

    print(f'K-mers in {hash_2} but not in {hash_1}:')
    print(f' - {kmers_only_in_2}')
    print()


if __name__ == "__main__":
    import sys
    print_kmer_data(sys.argv[1])
