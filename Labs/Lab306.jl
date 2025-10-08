#========================================================================================#
#	Laboratory 306: Flow dynamics and waves.
#
# Author: Niall Palfreyman, March 2025
#========================================================================================#
[
    Activity(
        """
        Hi! Welcome to Anatta Subject 306:
            Fields as independent dynamical entities.

        Fields are not only produced and consumed by agents; they are also entities in their own
        right, possessing their own highly complex dynamics, as we shall see in this lab. In fact,
        ALL biological systems contain two essential components: An agent structure that generates
        and utilises fields LOCALLY, and a set of dynamical fields that interact NONLOCALLY, which
        govern the extent of variation in the agent structures. These structures may be organisms,
        cells, neurons or genomes, and the fields may be food resources, messenger proteins, or
        transcription factors.

        In this lab we discover that fields are not just passive media that convey signals between
        agents, but are active entities in their own right that generate and transform themselves.
        We will model the nonlocal field dynamics of the waves underlying quantum particles and
        light photons, and see how these fields can generate complex interference and diffraction
        patterns. We will also use our agent-based model to visualise the complex phenomenon of
        interference - this pedagogical application is important in computer-aided instruction.
        """,
        "",
        x -> occursin("interfer",lowercase(x))
    ),
    Activity(
        """
        Load the module Maxwell, which implements a particular solution of Maxwells Equations.
        
        From 1862-1865, James Clerk Maxwell formulated his four equations to describe how electric
        and magnetic fields (E-fields and B-fields) are related to each other and to the wave
        phenomenon of light. In particular, Maxwell's equations demonstrate that fields possess an
        existence of their own - quite independent of the charged particles that generate them. The
        equations possess a symmetry that allows the fields to generate each other in a self-
        sustaining manner, forming waves that propagate themselves across the Universe without any
        material structures to support them.
        
        The central evidence for the wavelike nature of light is the effect simulated in the Maxwell
        module. Study the simulation Maxwell.demo() now, and tell me the correct name for the
        interaction that you observe between the two sets of waves.
        """,
        "Use the mouse cursor to find locations where the waves from the two synchronised sources " *
            "cancel each other out",
        x -> occursin("interfer",lowercase(x))
    ),
    Activity(
        """
        I have used the parameter "attenuation" to ensure that the wave pattern is not complicated
        by waves that flow over the edge of the model's world. Adjust the value of attenuation to
        zero, and observe the effect on the wave pattern. At the edge of the graphics
        representation, you can see that the waves wrap around to the other side of the world. This
        is a common feature of agent-based models, known as "periodic boundary conditions". Here,
        the waves look as though they are displaying a common wave phenomenon called ... what?
        """,
        "The edges look as if they are acting like mirrors",
        x -> occursin("refle",lowercase(x)) || occursin("bounc",lowercase(x))
    ),
    Activity(
        """
        Change the value of attenuation to its maximum allowed value, and observe the effect on the
        wave pattern. The waves now die out very quickly. You can use the 'sleep' parameter to slow
        down the simulation and see what is happening in more detail.

        Next, restore attenuation to its original value of 0.4 so that we can study the
        interference pattern of the waves. The interference pattern is a result of the
        superposition of the two waves:
        -   At points where the peaks of the two waves coincide, we say that the waves are In Phase
            with each other, and they add to form waves of maximum combined amplitude;
        -   At points where the peak of one wave coincides with the trough of the other, we say
            that the waves are In Anti-phase, and they cancel each other out to form waves of
            minimum amplitude.
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Notice how the interference maxima and minima form ray-like paths stretching outwards to
        right and left from the sources at varying angles. If we imagine the right-hand edge of
        the world as a projection screen, these paths would show up as a pattern of light (maximum)
        and dark (minimum) spots along that screen. This is the basis of Young's famous double-slit
        experiment, which demonstrates that light has an intrinsically wavelike nature.

        If we think of the two sources as two bases in a DNA molecule, each of which independently
        reflects outwards a single incoming x-ray wave, then you can see how the interference
        pattern might provide us with information about the distance between those bases, and help
        us explore the internal structure of the DNA molecule. This exactly what Rosalind Franklin
        did in 1952, when she used x-ray diffraction to discover the double-helix structure of DNA.
        Let's use our simulation to explore how x-ray crystallography works ...
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Notice that one ray-path of waves with maximum amplitude stretches horizontally to left and
        right from a point halfway between the two sources. Light travelling from each of the two
        sources to points along this path travel equal distances and so will be in phase with each
        other, and so will constructively interfere to form a bright spot on the screen. We call
        this spot the Zeroth-Order Maximum of the interference pattern, and is the brightest spot
        on the screen.
        
        The 1st-order maxima are the next brightest spots, appearing just above and below the
        zeroth-order maximum, where the path-lengths differ by exactly one x-ray wavelength λ. The
        angle θ between the zeroth- and 1st-order maxima is called the Angle of Diffraction; it is
        related to the wavelength λ and the distance d between the sources by Bragg's formula:
            sin(θ) = λ/d ,
        
        Test Bragg's formula by varying the value of d while observing the corresponding angle θ.
        As you use the slide to increase the value of d, does θ increase or decrease?
        """,
        "",
        x -> occursin("decr",lowercase(x))
    ),
    Activity(
        """
        Now that we have seen how waves and interference are essential features of light, let's
        see how these waves arise from their electric and magnetic field components. The electric
        field (E) is generated by the charge of the sources, and the magnetic field (B) is
        generated by the changing electric field. The two field strengths E and B are related by
        the speed of light c, which is the speed at which the waves propagate through space.
        
        The method Maxwell.model_step!() simulates this wave behaviour using Euler's method with
        the dynamical equations for the two phase variables E and B. It develops a numerical
        solution of the Wave Equation:
            ∂^2E/∂t^2 = c^2 * ∂^2(E)/∂x^2

        The wave equation describes two different phenomena: the spreading of fields through space
        and the wavelike excitation of those fields. The spatial derivatives on the RHS of the
        equation describe the spreading of fields, while the time derivatives on the LHS describe
        the wavelike excitation of fields. To explore these two phenomena separately, comment out
        line 107 of Maxwell.jl, and replace this line of code by:
            maxi.E[:] = maxi.B[:]

        What does this code do with the contents of the two matrices maxi.E and maxi.B?
        """,
        "Create a small matrix A in the REPL, then look at the result of the expression A[:]",
        x -> occursin("cop",lowercase(x))
    ),
    Activity(
        """
        By commenting out line 107 and replacing it with the new code, we have effectively
        converted the wave equation into the diffusion equation that we met in the previous lab:
            ∂E/∂t = c^2 * ∂^2(E)/∂x^2

        This diffusion equation specifies the rate of change of E in terms of its spatial
        curvature: regions of locally high E will diffuse outwards to regions of lower E. You can
        see that the method Maxwell.model_step!() calculates this curvature. Run Maxwell.demo()
        now, and observe how the changing E-field at the sources diffuses outwards without any
        oscillatory motion. This is similar to the behaviour of a front of varying cold or hot
        temperature that spreads outwards from an extreme source to moderate surrounding regions.

        Now think about this diffusion equation: If the local curvature ∂^2(E)/∂x^2 is very small,
        how large will the (first order) rate of change ∂E/∂t be? Or in other words:
            As the field E approaches a uniform temperature, will it move towards that uniform
            temperature quickly or slowly?
        """,
        "What is the relation between the spatial curvature of E and the rate of change of E?",
        x -> occursin("slow",lowercase(x))
    ),
    Activity(
        """
        What you have just found is a general property of first-order differential equations: as
        E approaches a uniform temperature, it changes reeeally slowly, because its spatial
        curvature specifies the first-order rate of change ∂E/∂t. For this reason, first-order
        differential equations can never produce oscillatory field activity, but only the slow,
        smooth spreading of fields.

        Now restore line 107 of Maxwell.jl to its original form and look at the structure of this
        new line of code. Earlier in Maxwell.model_step!(), the spatial curvature of E specifies
        the first-order derivative ∂B/∂t of B, so again, B will fall only slowly towards a uniform
        value. However, the value of B now no longer specifies E itself, but instead E's rate of
        change ∂E/∂t. In other words, the spatial curvature of E specifies the (second-order)
        Acceleration of E. This leaves E the freedom to overshoot and 'swing back' to its uniform
        value, so generating the oscillatory motion described by the wave equation:
            ∂^2E/∂t^2 = c^2 * ∂^2(E)/∂x^2

        By modifying the method Maxwell.maxwell(), you can add various sources to the model at
        different positions and with different frequencies and amplitudes. Do this, then run
        Maxwell.demo() again at various sleep speeds to convince yourself of this essential
        difference between the diffusion and wave equations: the wave equation allows for
        oscillatory motion, while the diffusion equation does not.
        """,
        "",
        x -> true
    ),
]