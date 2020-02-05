% technique v0
! Proprietary; © 2002-2019 Andrew Cowie

Christmas Dinner
================

Recepie for a classic Christmas dinner. It is probably worth noting that
this can be followed on most any high holiday. The only things you really
need are patience, guests, and a turkey.

    christmas_dinner : Context -> Dinner
    {
        ingredients = assemble_ingredients ()
        meal = prepare_meal ingredients
        dishes = serve_dinner meal
        done = cleanup_after dishes
        done
    }

Shopping list
=============

Turkey
------

For some reason people seem to think that they need an enormous bird. Don't
worry even if you are expecting a large party; if you've got lots of
relatives you can just leave out a few plates of cheese and crackers and
they'll be full long before dinner is served.

    turkey : () -> Ingredients
    {
        #butcher
        {
            [
                "Turkey" ~ 4 +/- 1 kg
                "Bacon" ~ 2 pieces
            ]
        }
    }

Stuffing
--------

Stuffing a bird actually makes it take longer to cook, but doing so adds
aroma, flavour, and helps preserve moisture and keeps the turkey tender.

    stuffing : () -> Ingredients
    {
        #store
        {
            [
                "Salt" ~ 1 teaspoon
                "Pepper" ~ 1 teaspoon
            ]
        }

        #grocer
        {
            [
                "Carrots" ~ 1 each
                "Celerey" ~ 0.5 stalk
            ]
        }

        #bakery
        {
            [
                "Bread" ~ 2 slices
            ]
        }
    }

Breaksauce
----------

This ancient recepie from Northern Yorkshire calls for ...

    breadsauce : () -> Ingredients
    {
        #bakery
        {
            [
                "Bread" ~ 4 slices
            ]
        }

        #store
        {
            [
                "Salt" ~ 1 teaspoon
                "Pepper" ~ 1 teaspoon
                "Cloves" ~ 4 teaspoons
                "Milk" ~ 100 mL
            ]
        }

        #grocer
        {
            [
                "Brown Onion" ~ 0.5 bulb
            ]
        }
    }

    assemble_ingredients : () -> Ingredients
    {
        @chef
        {
            turkey + stuffing + breadsauce
        }
    }

    prepare_meal i : Ingredients -> Meal
    {
        @chef
        {
            turkey = roast_turkey i
            potatoes = roast_potatoes i
            sauce = make_breadsauce i
            raw = prepare_vegetables i

            turkey & potatoes & sauce

            gravy = make_gravy i
            t1 = timer (3 hr)
            gravy | t1

            turkey & (potatoes | bag_of_chips)

            veggies,water = cook_vegetables raw

            gravy' = combine gravy,water
            gravy' & veggies

            temp = probe_bird_temperature turkey

            [
                "Final Temperature" ~ temp
            ]
        }
    }

Pour the vegetable water into the gravy
---------------------------------------

    combine g,w : Gravy,VegetableWater -> Gravy
    {
        @chef
        {
            task "Combine gravy and vegitable water"
            g & w
        }
    }

    roast_turkey i : Ingredients -> Turkey
    {
        @chef
        {
            temp = oven (180 °C)
            task "Bacon strips onto bird"
            temp

            task "Put bird into oven"

            t = timer (3 h)
            t
            [
                "Roast temperature" ~ temp
            ]
        }

        @asst
        {
            task "Set the table"
        }        
    }

Cook Vegetables
---------------

    cook_vegetables : VegetablesPrepared -> VegetablesCooked,VegetableWater
    {
        @chef
        {
            task "Boil water"
            task "Dunk greens in water"
        }
    }

Serve dinner and enjoy
======================

    serve_dinner : Meal -> DirtyDishes
    {}


Cleanup
=======

No one likes cleaning up. As far as I can tell, the only real justification
for having children is to help with doing the dishes on festive occasions.
Certainly I always hated my Aunt at holidays for making me dry _dishes_
with a _dish towel_ when they would _perfectly well air dry by themselves_.

    cleanup_after : DirtyDishes -> ()
    {}

Set oven temperature
--------------------

    oven temp : Temperature -> Action
    {
        @chef
        {
            task "Set temperature to ${temp}"
        }
    }

Put knives away
---------------

    knives_away : () -> Action
    {
        @*
        {
            task "Place knives in safe place"
            task "Start dishwasher"
        }
    }

    safe : () -> Procedure
    {
        @*
        {
            o = oven (0 °C)
            k = knives_away ()
            l = lights_out ()

            o & k & l
        }
    }
