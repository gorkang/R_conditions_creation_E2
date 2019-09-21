# https://towardsdatascience.com/an-introduction-to-web-browser-automation-with-selenium-and-docker-containers-c1bcbcb91540
# https://sondnm.github.io/blog/2018/09/08/i-just-learnt-about-/dev/shm/
docker run -d -v LOCAL_PATH://home/seluser/Downloads -p 4445:4444 --shm-size=2g — name YOUR_CONTAINER_NAME selenium/standalone-chrome
# The — shm-size option increases the size of the /dev/shm directory, which is a temporary file storage system. This is because the default shared memory on the container is too small for Chrome to run. I have had success with the size set at 2 gigabytes, following this github discussion.

df -h /dev/shm

# LINUX, change shm size
mount -o remount,size=2G /dev/shm



# https://docs.docker.com/config/containers/resource_constraints/
 # GPU & memory

  # memory=inf, memory-swap=inf (default)
    # No limit on memory? 
    # No limit on swap-space?
 # docker run -it --rm --gpus all ubuntu nvidia-smi

# https://docs.docker.com/engine/reference/run/
--memory-swap=""	
--cpus=0.000	# 0.000 NO LIMIT