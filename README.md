# Flow Chart Maker

Flow Chart Maker is a simple R script that builds interactive flow charts using the `VisNetwork` package. It takes as input an Excel file with at least three columns: `id`, `from`, and `name`. Users can add as many extra columns as they wish, and the information in these columns will be displayed as a popup when hovering over a node in the flow chart. The script will output an interactive flow chart in html format which can be opened and explored in any standard web browser. 

## Features

- Generates interactive flow charts from Excel files.
- Hovering the mouse over each node will reveal the additional information (one line per column in the excel file).
- Users can select specific nodes and visualize their ancestors/offspring. 

## Installation

To use the Flow Chart Maker script, you need to have R and RStudio installed on your system.

### Install R

1. Go to the [CRAN R Project website](https://cran.r-project.org/).
2. Download the appropriate version of R for your operating system.
3. Follow the installation instructions provided on the website.

### Install RStudio

1. Go to the [RStudio website](https://www.rstudio.com/products/rstudio/download/).
2. Download the free version of RStudio for your operating system.
3. Install RStudio by following the provided instructions.

### Install Required R Packages

The script automatically checks for the necessary packages and installs them if they are not already installed.
If you get the following warning:

> ```warning
> Warning in install.packages: unable to access index for repository
> http://cran.rstudio.com/src/contrib: cannot open URL
> ```

You might be behind a firewall that is preventing RStudio to access the CRAN repositories. As a workaround, you can change secure connection settings. 
Go to Tools -> Global Options -> Packages-> Management Tab-> Uncheck "Use secure download method for HTTP"
However, if you prefer to mantain using HTTPS for downloading (recommended), please refer to [this link](https://support.posit.co/hc/en-us/articles/206827897-Secure-Package-Downloads-for-R). 

## Usage

1. **Download the repository:**

   - Go to the [GitHub repository page](https://github.com/gabrielnegreira/flowchartMaker/):
   - Click on the green "Code" button.
   - Select "Download ZIP".
   - Extract the downloaded ZIP file to a directory on your computer.

2. **Open the script in RStudio:**

   - Open RStudio.
   - Go to `File -> Open File...` and navigate to the directory where you extracted the ZIP file.
   - Select the `Flow Chart Maker.R` script and open it.

3. **Run the script:**
   - Click on the scrip and press CTRL+A (CMD+A on MAC) to select the whole scritp.
   - Click on the "Run" button in RStudio to execute the script.
   - When you run the script, it will prompt you to select an Excel file. Ensure your Excel file has at least the following three columns:

      - id: Unique identifier for each node. Can be numeric or a string. IDs must be unique for each row.
      - from: Identifier of the node from which the current node originates. Must match an ID present in the id columns.
      - name: Name or label of the node.
   
   - The HTML file containing the flow chart will be generated in the same directory as the input file.
   - OBS: In principle the script can be ran from the R GUI, without needing RStudio. However, currently it will not work if ran from terminal, as it requires a GUI environment.

## Example

Here is an example of how your input Excel file might look:

| id | from | name        | info          |
|----|------|-------------|---------------|
| 1  |      | Start       | Starting node |
| 2  | 1    | Step 1      | First step    |
| 3  | 2    | Step 2      | Second step   |
| 4  | 2    | Step 3      | Third step    |

The flow chart then should look like this:
![Flow Chart Example](https://github.com/gabrielnegreira/flowchartMaker/blob/main/example.png?raw=true)

You can add as many columns as you wish, as long as `id`, `from`, and `name` are present.

## Author

Gabriel H. Negreira

## License

This project is licensed under the MIT License. See the LICENSE file for details.

## Acknowledgements

Special thanks to the developers of the `tidyverse`, `stringr`, `readr`, `visNetwork`, and `readxl` packages for providing the tools necessary for this script.
