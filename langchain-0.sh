#!/bin/bash

# Check for correct number of arguments
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <input1> <input2> <output_file>"
    exit 1
fi

# Assign arguments to variables
INPUT1="$1"
INPUT2="$2"
OUTPUT_FILE="$3"

# Create the Python script
cat << EOF > langchain-0.py
from langchain import PromptTemplate, OpenAI, LLMChain

def process_input(input1, input2):
    template = "Process {input1} and {input2}."
    prompt = PromptTemplate(template=template, input_variables=["input1", "input2"])
    llm_chain = LLMChain(prompt=prompt, llm=OpenAI(temperature=0.7), verbose=True)
    return llm_chain.predict(input1=input1, input2=input2)

result = process_input("$INPUT1", "$INPUT2")
print(result)
EOF

# Run the Python script and write output to the file
python3 langchain-0.py > "$OUTPUT_FILE"

