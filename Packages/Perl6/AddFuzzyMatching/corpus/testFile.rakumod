# Simple test file

role Simple::Role {

  token history { 'history'  }
  token recommend { 'recommend' | 'suggest' }
  token with-preposition { 'with' | 'using' | 'by' }
  token nearest-neighbors { 'nearest' 'neighbours' }
  token items-slot:sym<items> { 'items' }
  rule recommend-nns { <recommend> <nearest-neighbors> }

}
