from lark import Lark

LoveFood_parser = Lark(r"""
    lovefood : subject loveverb objectspec

    loveverb : "love"
             | "crave"
             | "demand"
             | "want"

    objectspec : objectlist
               | object
               | objects
               | objectsmult

    subject : "i"
            | "we"
            | "you"

    object : "sushi"
           | "a"? "chocolate"
           | "milk"
           | "an"? "ice" "cream"
           | "a"? "tangerine"

    objects : "sushi"
            | "chocolates"
            | "milks"
            | "ice" "creams"
            | "ice-creams"
            | "tangerines"

    objectsmult : SIGNED_NUMBER objects

    objectlistelem : ( object | objects | objectsmult )

    objectlist : objectlistelem ( AND? objectlistelem )*

    AND : "and"

    %import common.ESCAPED_STRING
    %import common.SIGNED_NUMBER
    %import common.WS
    %ignore WS

    """, start="lovefood")

text = 'i love 2 ice creams'
print( LoveFood_parser.parse(text) )
