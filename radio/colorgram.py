import numpy as np
#from mlxtend.plotting import heatmap
import matplotlib
import matplotlib.pyplot as plt
import pandas as pd
from datetime import date
import calendar
import csv
import os, sys, shutil
import dateutil.relativedelta 
from csvhandler import ConvertToCsv

def heatmap(data, row_labels, col_labels, ax=None,
            cbar_kw={}, cbarlabel="", cbaron=1, **kwargs):
    """
    Create a heatmap from a numpy array and two lists of labels.

    Parameters
    ----------
    data
        A 2D numpy array of shape (N, M).
    row_labels
        A list or array of length N with the labels for the rows.
    col_labels
        A list or array of length M with the labels for the columns.
    ax
        A `matplotlib.axes.Axes` instance to which the heatmap is plotted.  If
        not provided, use current axes or create a new one.  Optional.
    cbar_kw
        A dictionary with arguments to `matplotlib.Figure.colorbar`.  Optional.
    cbarlabel
        The label for the colorbar.  Optional.
    cbaron
        Whether or not to display the cbar
    **kwargs
        All other arguments are forwarded to `imshow`.
    """

    if not ax:
        ax = plt.gca()

    # Plot the heatmap
    im = ax.imshow(data, **kwargs)

    # Create colorbar
    if cbaron == 1: 
        cbar = ax.figure.colorbar(im, ax=ax, **cbar_kw)
        cbar.ax.set_ylabel(cbarlabel, rotation=-90, va="top", labelpad=5)
    else:
        cbar=None

    # We want to show all ticks...
    ax.set_xticks(np.arange(data.shape[1]))
    ax.set_yticks(np.arange(data.shape[0]))
    # ... and label them with the respective list entries.
    ax.set_xticklabels(col_labels)
    ax.set_yticklabels(row_labels)

    # Let the horizontal axes labeling appear on top.
    ax.tick_params(top=True, bottom=False,
                   labeltop=True, labelbottom=False)

    # Rotate the tick labels and set their alignment.
    plt.setp(ax.get_xticklabels(), rotation=-30, ha="right",
             rotation_mode="anchor")

    # Turn spines off and create white grid.
    #for edge, spine in ax.spines.items():
    #    spine.set_visible(False)

    ax.set_xticks(np.arange(data.shape[1]+1)-.5, minor=True)
    ax.set_yticks(np.arange(data.shape[0]+1)-.5, minor=True)
    #ax.grid(which="minor", color="w", linestyle='-', linewidth=3)
    ax.tick_params(which="minor", bottom=False, left=False)

    return im, cbar

def annotate_heatmap(im, data=None, valfmt="{x:.2f}",
                     textcolors=["black", "white"],
                     threshold=None, **textkw):
    """
    A function to annotate a heatmap.

    Parameters
    ----------
    im
        The AxesImage to be labeled.
    data
        Data used to annotate.  If None, the image's data is used.  Optional.
    valfmt
        The format of the annotations inside the heatmap.  This should either
        use the string format method, e.g. "$ {x:.2f}", or be a
        `matplotlib.ticker.Formatter`.  Optional.
    textcolors
        A list or array of two color specifications.  The first is used for
        values below a threshold, the second for those above.  Optional.
    threshold
        Value in data units according to which the colors from textcolors are
        applied.  If None (the default) uses the middle of the colormap as
        separation.  Optional.
    **kwargs
        All other arguments are forwarded to each call to `text` used to create
        the text labels.
    """

    if not isinstance(data, (list, np.ndarray)):
        data = im.get_array()

    # Normalize the threshold to the images color range.
    if threshold is not None:
        threshold = im.norm(threshold)
    else:
        threshold = im.norm(data.max())/2.

    # Set default alignment to center, but allow it to be
    # overwritten by textkw.
    kw = dict(horizontalalignment="center",
              verticalalignment="center")
    kw.update(textkw)

    # Get the formatter in case a string is supplied
    if isinstance(valfmt, str):
        valfmt = matplotlib.ticker.StrMethodFormatter(valfmt)

    # Loop over the data and create a `Text` for each "pixel".
    # Change the text's color depending on the data.
    texts = []
    for i in range(data.shape[0]):
        for j in range(data.shape[1]):
            kw.update(color=textcolors[int(im.norm(data[i, j]) > threshold)])
            text = im.axes.text(j, i, valfmt(data[i, j], None), **kw)
            texts.append(text)

    return texts


def main(srcpath, targpath, tod) :
    # 
    # start of main function
    #   

    try:
        os.makedirs(targpath)
    except:
        print('dir exists')

    # create heatmap for this month
    # named yyyymm.jpg eg 200206.jpg
    mthdays=calendar.monthrange(int(tod[:4]), int(tod[5:6]))[1]

    # read the RMOB file
    myarray= np.zeros((24,mthdays), dtype=int)
    with open(srcpath +'RMOB-'+tod+'.DAT') as myfile:
        mydata = csv.reader(myfile, delimiter=',')
        line_count=0
        for row in mydata:
            yr=row[0]
            yyyy=yr[0:6]
            dy = int(yr[6:8])
            hr = int(row[1])
            val  = int(row[2])
            #print(f'\t year {yyyy} day {dy} hour {row[1]} value {row[2]}')
            myarray[hr,dy-1]=val
            line_count += 1
        print(f'Processed {line_count} lines.')
    hrs=range(1,25)
    cnts=myarray[:,dy-1]
    dys="{:02d}".format(dy)

    fig, ax = plt.subplots()

    # labels for axes
    col_lbl=["0","","","3","","","6","","","9","","","12","","","15","","","18","","","21","",""]
    if mthdays == 31 :
        row_lbl=["1","","","","5","","","","","10",
            "","","","","15","","","","","20","","","","","25","","","","","30",""]
    elif mthdays == 30 :
        row_lbl=["1","","","","5","","","","","10",
            "","","","","15","","","","","20","","","","","25","","","","","30"]
    elif mthdays == 29 :
        row_lbl=["1","","","","5","","","","","10",
            "","","","","15","","","","","20","","","","","25","","","",""]
    else:
        row_lbl=["1","","","","5","","","","","10",
            "","","","","15","","","","","20","","","","","25","","",""]

    # generate  heatmap
    #
    im, _ = heatmap(myarray, col_lbl, row_lbl,
                    cmap="jet", cbarlabel="Meteors/hour")
    _ = annotate_heatmap(im, valfmt=" {x:.0f} ", fontsize=8, threshold=myarray.max()*3/4)
    fig.tight_layout()

    plt.ylabel('Hour', labelpad=-2)
    
    plt.text(0.5,1.1, 'Heatmap for '+ str(yyyy), horizontalalignment='center', transform=ax.transAxes, fontsize=15)
    plt.xlabel('Day of Month')
    plt.tight_layout()

    fname = targpath + str(yyyy)+'.jpg'
    plt.savefig(fname, dpi=300,bbox_inches='tight')
    plt.close()

    # now generate the text and bar graph for today
    # as per the RMOB graphs
    # named yyyymmdd.jpg eg 20201225.jpg 
    #
    matplotlib.pyplot.bar(x=hrs,height=cnts)
    plt.ylabel('Count')
    obs ="Observer:      Mark McIntyre"
    loc1="    Location:    001°3100 West "
    cntr="Country:        United Kingdom  "
    loc2="                    051°4900 North"
    city="City:              Oxford                 "
    freq=" Frequency: 143.05805"
    antn="Antenna:       3-element Yagi             "
    azim="     Az: 175° El: 3°               "
    rfpr="RF Preamp:   None             "
    recv="        Reciever:    RTL USB Dongle"
    obsm="Obs Method: Spectrum Lab"
    comp="Computer:    HP Laptop"
    plt.title(
        f'{obs:<30}{loc1:<30}\n{cntr:<30}{loc2:<30}\n{city:<30}{freq:<30}\n'+
        f'{antn:<30}{azim:<30}\n{rfpr:<30}{recv:<30}\n{obsm:<60}\n{comp:<60}\n\n'+
        'Tackley Meteor Station\nCount of detections per hour ' +str(yyyy) + '-'+dys, loc='left')

    plt.tight_layout()
    #plt.show()

    fname2 = targpath + str(yyyy)+dys+'.jpg'
    plt.savefig(fname2, dpi=300,bbox_inches='tight')
    plt.close()

    # create a single image combining the above two side by side 
    # again as per the RMOB data
    # named RMOB_yyyymm.jpg 
    #
    ax = plt.subplot(1, 2, 2)
    img1=plt.imread(fname)
    plt.axis('off')
    plt.imshow(img1)
    ax = plt.subplot(1, 2, 1)
    img2=plt.imread(fname2)
    plt.axis('off')
    plt.imshow(img2)

    # save this as RMOB_yyyymmdd.jpg
    #
    fname3 = targpath + 'RMOB_'+str(yyyy)+dys+'.jpg'
    plt.savefig(fname3, dpi=300,bbox_inches='tight')
    plt.close()

    # copy it to RMOB_latest.jpg
    #
    latfil = targpath + 'RMOB_latest.jpg'
    shutil.copy(fname3, latfil)

    # create three-month bar chart - this doesn't work so 
    # commented out for now
    #
    #mthcnts=myarray.flatten()
    #hrs=range(1,len(mthcnts)+1) 
    #matplotlib.pyplot.bar(x=hrs,height=mthcnts) 
    #plt.ylabel('Count')
    #plt.tight_layout()
    #fname4 = targpath + 'RMOB_'+str(yyyy)+'.jpg'
    #plt.savefig(fname4, dpi=300,bbox_inches='tight')
    #plt.close()

    # generate three-month heatmap
    #
    tod=date.today().strftime("%Y%m")
    mthdays=calendar.monthrange(date.today().year,date.today().month)[1]
    #m1=mthdays
    d2 = date.today() - dateutil.relativedelta.relativedelta(months=1)
    m2 = calendar.monthrange(d2.year, d2.month)[1]
    mthdays = mthdays + m2
    d3 = date.today() - dateutil.relativedelta.relativedelta(months=2)
    m3 = calendar.monthrange(d3.year, d3.month)[1]
    mthdays = mthdays + m3
    myarray= np.zeros((24,mthdays), dtype=int)

    # read in three months of data
    #
    with open(srcpath +'RMOB-'+d3.strftime("%Y%m")+'.DAT') as myfile:
        mydata = csv.reader(myfile, delimiter=',')
        line_count=0
        for row in mydata:
            yr=row[0]
            yyyy=yr[0:6]
            dy = int(yr[6:8])
            hr = int(row[1])
            val  = int(row[2])
            myarray[hr,dy-1]=val
            line_count += 1
        print(f'Processed {line_count} lines.')

    with open(srcpath +'RMOB-'+d2.strftime("%Y%m")+'.DAT') as myfile:
        mydata = csv.reader(myfile, delimiter=',')
        line_count=0
        for row in mydata:
            yr=row[0]
            yyyy=yr[0:6]
            dy = int(yr[6:8])+m3
            hr = int(row[1])
            val  = int(row[2])
            myarray[hr,dy-1]=val
            line_count += 1
        print(f'Processed {line_count} lines.')

    with open(srcpath +'RMOB-'+tod+'.DAT') as myfile:
        mydata = csv.reader(myfile, delimiter=',')
        line_count=0
        for row in mydata:
            yr=row[0]
            yyyy=yr[0:6]
            dy = int(yr[6:8])+m2+m3
            hr = int(row[1])
            val  = int(row[2])
            myarray[hr,dy-1]=val
            line_count += 1
        print(f'Processed {line_count} lines.')
    hrs=range(1,25)
    cnts=myarray[:,dy-1]

    fig, ax = plt.subplots()

    row_lbl= ["" for x in range(mthdays)]
    for i in range(mthdays):
        if not i%10: 
            if i >= (m3+m2):
                row_lbl[i] = str(i-m2-m3)
            elif i >= m3:
                row_lbl[i] = str(i-m3)
            else:
                row_lbl[i] = str(i)

    im, _ = heatmap(myarray, col_lbl, row_lbl,
                    cmap="jet", cbaron=0, cbarlabel="Meteors/hour")
    fig.tight_layout()

    plt.ylabel('Hour', labelpad=-2)
    plt.text=""
    plt.xlabel('Day of Month')
    plt.tight_layout()

    fname2 = targpath + str(yyyy)+'-3mths.jpg'
    plt.savefig(fname2, dpi=300,bbox_inches='tight')
    plt.close()
    shutil.copy(fname2, '3months-latest.jpg')


    # create CSV versions of the above suitable for UKMON
    # to consume
    #
    yr=yyyy[0:4]
    mt=yyyy[4:6]
    ConvertToCsv.doafile(yr,mt,dys, srcpath, srcpath+'/csv/')

if __name__ == '__main__':
    if len(sys.argv) > 1:
        srcpath=sys.argv[1]
    else:
        srcpath='c:/spectrum/'
    if len(sys.argv) > 2:
        targpath=sys.argv[2]
    else:
        targpath = srcpath+'rmob/'
    if len(sys.argv) > 3 :
        tod = str(sys.argv[3])
    else :
        tod=date.today().strftime("%Y%m")
    
    main(srcpath, targpath, tod)
