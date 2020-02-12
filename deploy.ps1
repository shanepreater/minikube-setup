# Make our working directory
mkdir -p target

# Create a source distribution of the kube hello code.
python setup.py test sdist

# Add the docker components to the working directory
cp dist/kubehello* target/kubehello.tar.gz
cp docker/Dockerfile target

# Build the docker image
docker build -t kubehello:latest target

# Finally remove the working directory
rm -r target