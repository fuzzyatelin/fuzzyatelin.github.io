library(shiny)
  
  ui <- fluidPage(
    
    # App title ----
    titlePanel("True HWE Calculator"),
    
    # Sidebar layout with input and output definitions ----
    sidebarLayout(
      
      # Sidebar panel for inputs ----
      sidebarPanel(
        
        # Input: Slider for the number of bins ----
        
        numericInput("hetero", 
                     "Heterozygous Genotype Count", 
                     0),
        
        numericInput("hom1", 
                     "Homozygous 1 Genotype Count", 
                     0),
        
        numericInput("hom2", 
                     "Homozygous 2 Genotype Count", 
                     0)
        
      ),
      
      # Main panel for displaying outputs ----
      mainPanel(
        
        
        textOutput("HWE")
        
      )
    )
  )
  
  server = function(input, output) {
    
    output$HWE <- renderText({if (input$hom1 < 0 || input$hom2 < 0 || input$hetero < 0)
      return(-1.0)
      
      # total number of genotypes
      N <- input$hom1 + input$hom2 + input$hetero
      
      # rare homozygotes, common homozygotes
      obs_homr <- min(input$hom1, input$hom2)
      obs_homc <- max(input$hom1, input$hom2)
      
      # number of rare allele copies
      rare  <- obs_homr * 2 + input$hetero
      
      # Initialize probability array
      probs <- rep(0, 1 + rare)
      
      # Find midpoint of the distribution
      mid <- floor(rare * ( 2 * N - rare) / (2 * N))
      if ( (mid %% 2) != (rare %% 2) ) mid <- mid + 1
      
      probs[mid + 1] <- 1.0
      mysum <- 1.0
      
      # Calculate probablities from midpoint down 
      curr_hets <- mid
      curr_homr <- (rare - mid) / 2
      curr_homc <- N - curr_hets - curr_homr
      
      while ( curr_hets >=  2)
      {
        probs[curr_hets - 1]  <- probs[curr_hets + 1] * curr_hets * (curr_hets - 1.0) / (4.0 * (curr_homr + 1.0)  * (curr_homc + 1.0))
        mysum <- mysum + probs[curr_hets - 1]
        
        # 2 fewer heterozygotes -> add 1 rare homozygote, 1 common homozygote
        curr_hets <- curr_hets - 2
        curr_homr <- curr_homr + 1
        curr_homc <- curr_homc + 1
      }    
      
      # Calculate probabilities from midpoint up
      curr_hets <- mid
      curr_homr <- (rare - mid) / 2
      curr_homc <- N - curr_hets - curr_homr
      
      while ( curr_hets <= rare - 2)
      {
        probs[curr_hets + 3] <- probs[curr_hets + 1] * 4.0 * curr_homr * curr_homc / ((curr_hets + 2.0) * (curr_hets + 1.0))
        mysum <- mysum + probs[curr_hets + 3]
        
        # add 2 heterozygotes -> subtract 1 rare homozygtote, 1 common homozygote
        curr_hets <- curr_hets + 2
        curr_homr <- curr_homr - 1
        curr_homc <- curr_homc - 1
      }    
      
      # P-value calculation
      target <- probs[input$hetero + 1]
      
      #plo <- min(1.0, sum(probs[1:obs_hets + 1]) / mysum)
      
      #phi <- min(1.0, sum(probs[obs_hets + 1: rare + 1]) / mysum)
      
      # This assignment is the last statement in the fuction to ensure 
      # that it is used as the return value
      p <- min(1.0, sum(probs[probs <= target])/ mysum)})
    
  }

  shinyApp(ui=ui,server=server)