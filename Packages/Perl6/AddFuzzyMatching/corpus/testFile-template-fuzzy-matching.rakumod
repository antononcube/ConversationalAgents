
# Simple test file
role Simple {
token  recommend {'recommend' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'recommend') }> }
token nearest-neighbors { 'nearest' 'neighbours' }
rule recommend-nns { <recommend> <nearest-neighbors> }
}

