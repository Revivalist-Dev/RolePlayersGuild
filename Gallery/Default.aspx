<%@ Page Title="" Language="C#" MasterPageFile="~/templates/1-Col.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.Gallery.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="FullCol" runat="server">

    <div class="modal fade" id="confirm-ViewMatureContent" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content alert-danger">

                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title" id="confirm-ViewMatureContentLabel">Are you sure?</h4>
                </div>

                <div class="modal-body">
                    <p>The content you are requesting to see is marked as being for mature audiences only. By continuing, you agree that you are old enough to see the content.</p>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Nevermind</button>
                    <a class="btn btn-danger btn-ok">I understand</a>
                </div>
            </div>
        </div>
    </div>

    <script>
        $('#confirm-ViewMatureContent').on('show.bs.modal', function (e) {
            $(this).find('.btn-ok').attr('href', $(e.relatedTarget).data('href'));
        });
    </script>
    <asp:Panel ID="pnlMessage" runat="server" ViewStateMode="Disabled" Visible="false" role="alert">
        <asp:Literal ID="litMessage" runat="server" ViewStateMode="Disabled"></asp:Literal>
    </asp:Panel>

    <div class="ButtonPanel clearfix">
        <div class="col-xl-3 col-sm-4 col-xs-12">
            <asp:HyperLink runat="server" ID="lnkAddPhoto" NavigateUrl="#" CssClass="btn btn-success" Visible="false">
            <span class="glyphicon glyphicon-plus"></span>
            New Image</asp:HyperLink>
        </div>
        <div class="col-xl-3 col-sm-4 col-xs-12">
        </div>
        <div class="col-xl-3 col-sm-4 col-xs-12 col-xl-offset-3">
            <a href="/Character?id=<%= Request.QueryString["id"].ToString() %>" class="btn btn-primary">Back to Profile</a>
        </div>
    </div>

    <fieldset class="MyImageList">
        <legend>Gallery</legend>
        <asp:ListView ID="lvImages" runat="server" GroupItemCount="6" OnItemDataBound="lvImages_ItemDataBound">
            <LayoutTemplate>
                <div runat="server" id="groupPlaceholder">
                </div>
            </LayoutTemplate>
            <GroupTemplate>
                <%--<div class="row row-eq-height">--%>
                <div runat="server" id="itemPlaceholder"></div>
                <%--</div>--%>
            </GroupTemplate>
            <ItemTemplate>
                <div runat="server" id="divContainerDiv" class="Item col-sm-2 col-xl-1">
                    <a data-toggle="modal" <%# MatureContentWarning(Eval("IsMature")) %>href="/Gallery/Image?ImageID=<%# Eval("CharacterImageID") %>" class="Image thumbnail">
                        <span runat="server" id="spanImageCommentBadge" class="badge" visible="false"></span>
                        <img class="lazyload" src="<%# DisplayImageString(Eval("CharacterImageURL").ToString(), "thumb", Eval("IsMature")) %>" /></a>
                </div>
            </ItemTemplate>
        </asp:ListView>
        <%--<asp:SqlDataSource ID="sdsImages" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="">
            <SelectParameters>
                <asp:QueryStringParameter Name="CharacterID" QueryStringField="id" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>--%>
    </fieldset>
    <div class="clearfix">
        <nav class="PagingControls">
            <ul class="pagination">
                <%--                    <li>
                        <asp:LinkButton ID="lbFirst" runat="server"
                            OnClick="lbFirst_Click">Newest</asp:LinkButton>
                    </li>--%>
                <li class="previous">
                    <asp:LinkButton ID="lbFirst" runat="server"
                        OnClick="lbFirst_Click" aria-label="First"><span aria-hidden="true">&laquo;</span></asp:LinkButton>
                </li>
                <asp:Repeater ID="rptPaging" runat="server"
                    OnItemCommand="rptPaging_ItemCommand"
                    OnItemDataBound="rptPaging_ItemDataBound">
                    <ItemTemplate>
                        <li>
                            <asp:LinkButton ID="lbPaging" runat="server"
                                CommandArgument='<%# Eval("PageIndex") %>'
                                CommandName="newPage"
                                Text='<%# Eval("PageText") %>'>
                            </asp:LinkButton>
                        </li>
                    </ItemTemplate>
                </asp:Repeater>

                <li class="next">
                    <asp:LinkButton ID="lbLast" runat="server" aria-label="Last"
                        OnClick="lbLast_Click"><span aria-hidden="true">&raquo;</span></asp:LinkButton>
                </li>
                <%--                    <li class="next">
                        <asp:LinkButton ID="lbLast" runat="server"
                            OnClick="lbLast_Click">Oldest</asp:LinkButton>
                    </li>--%>
            </ul>
        </nav>
    </div>
</asp:Content>
